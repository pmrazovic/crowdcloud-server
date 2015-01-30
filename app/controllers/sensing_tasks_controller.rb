require 'sensing_task_status'
class SensingTasksController < ApplicationController
  before_action :set_sensing_task, only: [:show, :edit, :update, :destroy, :delete, :confirm_publish ,:publish, :devices, 
                                          :sensing_responses, :sensing_response_details, :get_responses]
  skip_before_filter :authenticate_account!, :only => [:list_sensing_tasks, :get_sensing_task, :fetch_sensing_data_types, :publish_new, :get_responses, :get_response]
  load_and_authorize_resource :except => [:list_sensing_tasks, :get_sensing_task, :fetch_sensing_data_types, :publish_new, :get_responses, :get_response]
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
    send_push_messages(@sensing_task)
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
    status = :ok
    begin
    sensing_tasks = SensingTask.where(:status => SensingTaskStatus::PUBLISHED.to_s)
                         .order("created_at DESC")
                         .paginate(:page => params[:page], :per_page => 20)
                         .collect{ |oc| { :id => oc.id, 
                                          :name => oc.name,
                                          :published_at => oc.published_at,
                                          :crowdsourcer => (oc.crowdsourcer_type == 'Account' ? "#{oc.crowdsourcer.first_name} #{oc.crowdsourcer.last_name}" : "#{oc.crowdsourcer.uuid}"),
                                          :crowdsourcer_type => oc.crowdsourcer_type,
                                          :responded => SensingResponse.exists?(:sensable_id => oc.id, :sensable_type => "SensingTask", :device_id => params[:device_id]) }
                                  }
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end
    render :json => (status == :ok ? sensing_tasks.to_json : ''), :status => status
  end

  def get_sensing_task
    status = :ok
    oc = SensingTask.find(params[:id])
    if oc.nil?
      status = :bad_request
    else
      begin
        sensing_task = { :id => oc.id, 
                         :name => oc.name,
                         :description => oc.description,
                         :created_at => oc.created_at,
                         :published_at => oc.published_at,
                         :sensing_data_types => oc.sensing_data_types.collect{ |t| t.name },
                         :crowdsourcer => (oc.crowdsourcer_type == 'Account' ? "#{oc.crowdsourcer.first_name} #{oc.crowdsourcer.last_name}" : "#{oc.crowdsourcer.uuid}"),
                         :crowdsourcer_type => oc.crowdsourcer_type,
                         :responded => SensingResponse.exists?(:sensable_id => oc.id, :sensable_type => "SensingTask", :device_id => params[:device_id]) }
      rescue Exception => e
        status = :internal_server_error
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end                         
    end
    render :json => (status == :ok ? sensing_task.to_json : ''), :status => status
  end

  def get_responses
    status = :ok
    begin
      sensing_task_responses = @sensing_task.sensing_responses
                                            .joins(:device)
                                            .order(:created_at)
                                            .paginate(:page => params[:page], :per_page => 20)
                                            .select("sensing_responses.id, sensing_responses.created_at, devices.uuid")
                                            .collect{ |r| { :id => r.id,
                                                            :created_at => r.created_at,
                                                            :device_uuid => r.uuid } }
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end
    render :json => (status == :ok ? sensing_task_responses.to_json : ''), :status => status
  end

  def get_response
    status = :ok
    data = []
    sensing_task_response = SensingResponse.find(params[:response_id])
    if sensing_task_response.nil?
      status = :bad_request
    else
      begin
        sensing_task_response.sensing_response_items.each do |response_item|
          sensor_data = response_item.sensing_response_data.as_json.merge(:type => response_item.sensing_response_data_type)
          data << sensor_data
        end
      rescue Exception => e
        status = :internal_server_error
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end
    end
    render :json => (status == :ok ? data.to_json : ''), :status => status
  end

  def fetch_sensing_data_types
    status = :ok
    begin
      sensing_data_types = SensingDataType.order(:name).collect{|type| {:name => type.name, :enabled => type.enabled, :id => type.id} }
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end
    render :json => (status == :ok ? sensing_data_types.to_json : ''), :status => status
  end

  def publish_new
    status = :ok
    begin
      sensing_task = SensingTask.new(:crowdsourcer_id => params[:crowdsourcer_id],
                                     :crowdsourcer_type => params[:crowdsourcer_type],
                                     :name => params[:name],
                                     :description => params[:description],
                                     :sensing_data_type_ids => params[:sensing_data_type_ids],
                                     :status => SensingTaskStatus::PUBLISHED.to_s,
                                     :published_at => Time.now)
      sensing_task.save!
      send_push_messages(sensing_task)
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end

    render :json => '', :status => status 
  end

  private

    def send_push_messages(sensing_task)
      if sensing_task.crowdsourcer_type == 'Device'
        push_ids = Device.where("id != #{sensing_task.crowdsourcer_id}").collect{|d| d.push_id}
      else
        push_ids = Device.all.collect{|d| d.push_id}
      end
      options = {:data => { :title => "Sensing task: #{sensing_task.name}", 
                            :message => "New sensing task has been published",
                            :task => { :id => sensing_task.id,
                                       :type => "SensingTask" }}}

      gcm_response = GCM.send(push_ids, options)
    end

    def set_sensing_task
      @sensing_task = SensingTask.find(params[:id])
    end

    def sensing_task_params
      params.require(:sensing_task).permit(:crowdsourcer_id, :crowdsourcer_type, :name, :description, :sensing_data_type_ids => [])
    end
end
