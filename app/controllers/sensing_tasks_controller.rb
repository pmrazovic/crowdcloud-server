require 'sensing_task_status'
class SensingTasksController < ApplicationController
  before_action :set_sensing_task, only: [:show, :edit, :update, :destroy, :delete, :confirm_publish ,:publish, :devices, 
                                          :sensing_responses, :sensing_response_details]
  skip_before_filter :authenticate_account!, :only => [:list_sensing_tasks, :get_sensing_task]
  load_and_authorize_resource :except => [:list_sensing_tasks, :get_sensing_task]
  skip_before_filter :verify_authenticity_token, :only => [:list_sensing_tasks], :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @sensing_tasks = SensingTask.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def show
  end

  def new
    @sensing_task = SensingTask.new
  end

  def edit
  end

  def create
    @sensing_task = SensingTask.new(sensing_task_params)

    respond_to do |format|
      if @sensing_task.save
        format.html { redirect_to @sensing_task, notice: 'Sensing task was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      unless params[:sensing_task].has_key?(:sensing_data_type_ids)
        params[:sensing_task][:sensing_data_type_ids] = []
      end
      if @sensing_task.update(sensing_task_params)
        format.html { redirect_to @sensing_task, notice: 'Sensing task was successfully updated.' }
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
      if @sensing_task.destroy
        flash[:success] = "Sensing task was successfuly removed from CrowdCloud!"
        redirect_to :action => :index
      else
        flash[:error] = "Unable to remove open call!"
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
    # push_ids = @sensing_task.devices.collect{|op| op.push_id}
    @sensing_task.status = SensingTaskStatus::PUBLISHED.to_s
    @sensing_task.published_at = Time.now
    @sensing_task.save
    push_ids = Device.all.collect{|d| d.push_id}
    options = {:data => { :title => "Sensing task: #{@sensing_task.name}", 
                          :message => "New sensing task has been published",
                          :task => { :id => @sensing_task.id,
                                     :type => "SensingTask" }}}

    gcm_response = GCM.send(push_ids, options)
    respond_to do |format|
      format.html { redirect_to @sensing_task, notice: 'Sensing task is successfully published.' }
    end
  end

  def devices
  end

  def sensing_responses
    @sensing_responses = @sensing_task.sensing_responses.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def sensing_response_details
    @sensing_response = SensingResponse.find(params[:sensing_response_id])
  end

  # Sensing task Api -------------------

  def list_sensing_tasks
    sensing_tasks = SensingTask.where(:status => SensingTaskStatus::PUBLISHED.to_s)
                         .order("created_at DESC")
                         .paginate(:page => params[:page], :per_page => 20)
                         .collect{ |oc| { :id => oc.id, 
                                          :name => oc.name,
                                          :published_at => oc.published_at,
                                          :crowdsourcer_name => "#{oc.account.first_name} #{oc.account.last_name}",
                                          :crowdsourcer_email => oc.account.email,
                                          :responded => SensingResponse.exists?(:sensable_id => oc.id, :sensable_type => "SensingTask", :device_id => params[:device_id]) }
                                  }
    render :json => sensing_tasks.to_json
  end

  def get_sensing_task
    oc = SensingTask.find(params[:id])
    sensing_task = { :id => oc.id, 
                  :name => oc.name,
                  :description => oc.description,
                  :created_at => oc.created_at,
                  :published_at => oc.published_at,
                  :sensing_data_types => oc.sensing_data_types.collect{ |t| t.name },
                  :crowdsourcer_name => "#{oc.account.first_name} #{oc.account.last_name}",
                  :crowdsourcer_email => oc.account.email,
                  :responded => SensingResponse.exists?(:sensable_id => oc.id, :sensable_type => "SensingTask", :device_id => params[:device_id]) }

    puts params.inspect
    render :json => sensing_task.to_json
  end

  private
    def set_sensing_task
      @sensing_task = SensingTask.find(params[:id])
    end

    def sensing_task_params
      params.require(:sensing_task).permit(:account_id, :name, :description, :sensing_data_type_ids => [])
    end
end
