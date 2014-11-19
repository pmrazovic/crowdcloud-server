require 'human_intelligence_task_status'
class HumanIntelligenceTasksController < ApplicationController
  before_action :set_hit, only: [:show, :edit, :update, :destroy, :delete, :confirm_publish ,:publish, 
                                 :devices, :step_2, :confirm_step_2, :step_3, :confirm_step_3, :step_4, 
                                 :confirm_step_4, :finish_formulation]
  # skip_before_filter :authenticate_account!, :only => [:list_sensing_tasks, :get_sensing_task]
  # load_and_authorize_resource :except => [:list_sensing_tasks, :get_sensing_task]
  # skip_before_filter :verify_authenticity_token, :only => [:list_sensing_tasks], :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @hits = HumanIntelligenceTask.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def show
  end

  def new
    @hit = HumanIntelligenceTask.new
  end

  def edit
  end

  # Creation steps

  def step_1
    @hit = HumanIntelligenceTask.new()
    unless params[:existing_hit_id].blank?
      HumanIntelligenceTask.find(params[:existing_hit_id]).destroy
    end
  end

  def confirm_step_1
    @hit = HumanIntelligenceTask.new(hit_params)
    @hit.status = HumanIntelligenceTaskStatus::STEP_1.name.to_s
    if @hit.save
      redirect_to step_2_human_intelligence_task_path(@hit)
    else
      render :step_1
    end
  end

  def step_2
  end

  def confirm_step_2
    if @hit.status == HumanIntelligenceTaskStatus::STEP_1.name.to_s
      @hit.status = HumanIntelligenceTaskStatus::STEP_2.name.to_s
      @hit.save
    end
    redirect_to step_3_human_intelligence_task_path(@hit)
  end

  def step_3
  end

  def confirm_step_3
    if @hit.status == HumanIntelligenceTaskStatus::STEP_2.name.to_s
      @hit.status = HumanIntelligenceTaskStatus::STEP_3.name.to_s
      @hit.save
    end
    if params[:human_intelligence_task].blank?
      params[:human_intelligence_task] = {:response_data_type_ids => []}
    end
    @hit.update_attributes(hit_params)
    redirect_to step_4_human_intelligence_task_path(@hit)
  end

  def step_4
  end

  def confirm_step_4
    @hit.status = HumanIntelligenceTaskStatus::PENDING.name.to_s
    @hit.save
    @hit.update_attributes(hit_params)
    redirect_to human_intelligence_task_path(@hit)
  end

  def finish_formulation
    if @hit.status == HumanIntelligenceTaskStatus::STEP_1.name.to_s
      redirect_to step_2_human_intelligence_task_path(@hit)
    elsif @hit.status == HumanIntelligenceTaskStatus::STEP_2.name.to_s
      redirect_to step_3_human_intelligence_task_path(@hit)
    elsif  @hit.status == HumanIntelligenceTaskStatus::STEP_3.name.to_s
      redirect_to step_4_human_intelligence_task_path(@hit)
    end
  end

  def create
    @hit = HumanIntelligenceTask.new(hit_params)

    respond_to do |format|
      if @hit.save
        format.html { redirect_to @hit, notice: 'Human intelligence task was successfully created.' }
      else
        format.html { render :new_question }
      end
    end
  end

  def update
    respond_to do |format|
      unless params[:human_intelligence_task].has_key?(:response_data_type_ids)
        params[:hit][:response_data_type_ids] = []
      end
      if @hit.update(hit_params)
        format.html { redirect_to @hit, notice: 'Human intelligence task was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def delete
  end

  def destroy
    password = params[:password]
    if current_account.valid_password?(password)
      if @hit.destroy
        flash[:success] = "Human intelligence task was successfuly removed from CrowdCloud!"
        redirect_to :action => :index
      else
        flash[:error] = "Unable to remove human intelligence task!"
        redirect_to :action => :delete
      end
    else
      flash[:error] = "Incorrect password!"
      redirect_to :action => :delete
    end
  end

  def confirm_publish
  end

  def publish
    # push_ids = @hit.devices.collect{|op| op.push_id}
    @hit.status = HumanIntelligenceTaskStatus::PUBLISHED.to_s
    @hit.published_at = Time.now
    @hit.save
    push_ids = Device.all.collect{|d| d.push_id}
    options = {:data => { :title => "HIT: #{@hit.name}", 
                          :message => "New HIT has been published",
                          :task => { :id => @hit.id,
                                     :type => "SensingTask",
                                     :name => @hit.name,
                                     :description => @hit.description,
                                     :published_at => @hit.published_at,
                                     :response_data_types => @hit.response_data_types.collect{ |type| type.name } } }}

    gcm_response = GCM.send(push_ids, options)
    respond_to do |format|
      format.html { redirect_to @hit, notice: 'Human intelligence task is successfully published.' }
    end
  end

  def devices
  end

  # Sensing task Api -------------------

  # def list_sensing_tasks
  #   sensing_tasks = SensingTask.where(:status => SensingTaskStatus::PUBLISHED.to_s)
  #                        .order("created_at DESC")
  #                        .paginate(:page => params[:page], :per_page => 20)
  #                        .collect{ |oc| { :id => oc.id, 
  #                                         :name => oc.name,
  #                                         :published_at => oc.published_at,
  #                                         :crowdsourcer_name => "#{oc.account.first_name} #{oc.account.last_name}",
  #                                         :crowdsourcer_email => oc.account.email,
  #                                         :responded => Response.exists?(:task_id => oc.id, :task_type => "SensingTask", :device_id => params[:device_id]) }
  #                                 }
  #   render :json => sensing_tasks.to_json
  # end

  # def get_sensing_task
  #   oc = SensingTask.find(params[:id])
  #   sensing_task = { :id => oc.id, 
  #                 :name => oc.name,
  #                 :description => oc.description,
  #                 :created_at => oc.created_at,
  #                 :published_at => oc.published_at,
  #                 :response_data_types => oc.response_data_types.collect{ |t| t.name },
  #                 :crowdsourcer_name => "#{oc.account.first_name} #{oc.account.last_name}",
  #                 :crowdsourcer_email => oc.account.email,
  #                 :responded => Response.exists?(:task_id => oc.id, :task_type => "SensingTask", :device_id => params[:device_id]) }

  #   puts params.inspect
  #   render :json => sensing_task.to_json
  # end

  private
    def set_hit
      @hit = HumanIntelligenceTask.find(params[:id])
    end

    def hit_params
      params.require(:human_intelligence_task).permit(:account_id, :question, :description, :response_data_type_ids => [])
    end
end
