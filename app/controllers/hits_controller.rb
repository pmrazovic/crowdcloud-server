require 'hit_status'
class HitsController < ApplicationController
  before_action :set_hit, only: [:show, :edit, :update, :destroy, :delete, :confirm_publish ,:publish, 
                                 :devices, :step_2, :confirm_step_2, :step_3, :confirm_step_3, :step_4, 
                                 :confirm_step_4, :finish_formulation, :manage_hit_choices]
  skip_before_filter :authenticate_account!, :only => [:list_hits, :get_hit]
  load_and_authorize_resource :except => [:list_hits, :get_hit]
  skip_before_filter :verify_authenticity_token, :only => [:list_hits], :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @hits = Hit.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def show
  end

  def edit
  end

  def new
    @hit = Hit.new
  end

  def manage_hit_choices
  end

  # Creation steps

  def step_1
    @hit = Hit.new()
    unless params[:existing_hit_id].blank?
      Hit.find(params[:existing_hit_id]).destroy
    end
  end

  def confirm_step_1
    @hit = Hit.new(hit_params)
    @hit.status = HitStatus::STEP_1.name.to_s
    if @hit.save
      redirect_to step_2_hit_path(@hit)
    else
      render :step_1
    end
  end

  def step_2
  end

  def confirm_step_2
    if @hit.status == HitStatus::STEP_1.name.to_s
      @hit.status = HitStatus::STEP_2.name.to_s
      @hit.save
    end
    redirect_to step_3_hit_path(@hit)
  end

  def step_3
  end

  def confirm_step_3
    if @hit.status == HitStatus::STEP_2.name.to_s
      @hit.status = HitStatus::STEP_3.name.to_s
      @hit.save
    end
    if params[:hit].blank?
      params[:hit] = {:response_data_type_ids => []}
    end
    @hit.update_attributes(hit_params)
    redirect_to step_4_hit_path(@hit)
  end

  def step_4
  end

  def confirm_step_4
    @hit.status = HitStatus::PENDING.name.to_s
    @hit.save
    @hit.update_attributes(hit_params)
    redirect_to hit_path(@hit)
  end

  def finish_formulation
    if @hit.status == HitStatus::STEP_1.name.to_s
      redirect_to step_2_hit_path(@hit)
    elsif @hit.status == HitStatus::STEP_2.name.to_s
      redirect_to step_3_hit_path(@hit)
    elsif  @hit.status == HitStatus::STEP_3.name.to_s
      redirect_to step_4_hit_path(@hit)
    end
  end

  def create
    @hit = Hit.new(hit_params)

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
      unless params[:hit].has_key?(:response_data_type_ids)
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
    @hit.status = HitStatus::PUBLISHED.to_s
    @hit.published_at = Time.now
    @hit.save
    push_ids = Device.all.collect{|d| d.push_id}
    options = {:data => { :title => "New HIT has been published", 
                          :message => "#{@hit.question}",
                          :task => { :id => @hit.id,
                                     :type => "Hit" }} }

    gcm_response = GCM.send(push_ids, options)
    redirect_to @hit, notice: 'Human intelligence task is successfully published.'
  end

  def devices
  end

  # HIT Api -------------------

  def list_hits
    hits = Hit.where(:status => HitStatus::PUBLISHED.to_s)
                     .order("created_at DESC")
                     .paginate(:page => params[:page], :per_page => 20)
                     .collect{ |oc| { :id => oc.id, 
                                      :question => oc.question,
                                      :published_at => oc.published_at,
                                      :crowdsourcer_name => "#{oc.account.first_name} #{oc.account.last_name}",
                                      :crowdsourcer_email => oc.account.email,
                                      :responded => Response.exists?(:task_id => oc.id, :task_type => "Hit", :device_id => params[:device_id]) }
                                    }
    render :json => hits.to_json
  end

  def get_hit
    oc = Hit.find(params[:id])
    hit = { :id => oc.id, 
            :question => oc.question,
            :description => oc.description,
            :created_at => oc.created_at,
            :published_at => oc.published_at,
            :choices => oc.hit_choices.order("id ASC").collect { |c| {:id => c.id, :description => c.description} },
            :context_data_types => oc.response_data_types.collect { |t| t.name },
            :crowdsourcer_name => "#{oc.account.first_name} #{oc.account.last_name}",
            :crowdsourcer_email => oc.account.email,
            :responded => Response.exists?(:task_id => oc.id, :task_type => "Hit", :device_id => params[:device_id]) }

    puts params.inspect
    render :json => hit.to_json
  end

  private
    def set_hit
      @hit = Hit.find(params[:id])
    end

    def hit_params
      params.require(:hit).permit(:account_id, :question, :description, :response_data_type_ids => [])
    end
end
