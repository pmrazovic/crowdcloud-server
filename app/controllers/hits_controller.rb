require 'hit_status'
class HitsController < ApplicationController
  before_action :set_hit, only: [:show, :edit, :update, :destroy, :delete, :confirm_publish ,:publish, 
                                 :devices, :step_2, :confirm_step_2, :step_3, :confirm_step_3, :step_4, 
                                 :confirm_step_4, :finish_formulation, :manage_hit_choices, :responses, :get_responses]
  skip_before_filter :authenticate_account!, :only => [:list_hits, :get_hit, :get_responses, :get_response]
  load_and_authorize_resource :except => [:list_hits, :get_hit, :get_responses, :get_response]
  skip_before_filter :verify_authenticity_token, :only => [:list_hits, :get_responses, :get_response], :if => Proc.new { |c| c.request.format == 'application/json' }

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
      params[:hit] = {:sensing_data_type_ids => []}
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
      unless params[:hit].has_key?(:sensing_data_type_ids)
        params[:hit][:sensing_data_type_ids] = []
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

  def responses
    @hit_responses = @hit.hit_responses
  end

  # HIT Api -------------------

  def list_hits
    status = :ok
    begin
      hits = Hit.where(:status => HitStatus::PUBLISHED.to_s)
                       .order("created_at DESC")
                       .paginate(:page => params[:page], :per_page => 20)
                       .collect{ |oc| { :id => oc.id, 
                                        :question => oc.question,
                                        :published_at => oc.published_at,
                                        :crowdsourcer => (oc.crowdsourcer_type == 'Account' ? "#{oc.crowdsourcer.first_name} #{oc.crowdsourcer.last_name}" : "#{oc.crowdsourcer.uuid}"),
                                        :crowdsourcer_type => oc.crowdsourcer_type,
                                        :responded => !oc.hit_responses.where(:device_id => params[:device_id]).blank? }
                                      }
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end  
    render :json => (status == :ok ? hits.to_json : ''), :status => status
  end

  def get_hit
    status = :ok
    oc = Hit.find(params[:id])
    if oc.nil?
      status = :bad_request
    else
      begin
        hit = { :id => oc.id, 
                :question => oc.question,
                :description => oc.description,
                :created_at => oc.created_at,
                :published_at => oc.published_at,
                :choices => oc.hit_choices.order("id ASC").collect { |c| {:id => c.id, :description => c.description} },
                :context_data_types => oc.sensing_data_types.collect { |t| t.name },
                :crowdsourcer => (oc.crowdsourcer_type == 'Account' ? "#{oc.crowdsourcer.first_name} #{oc.crowdsourcer.last_name}" : "#{oc.crowdsourcer.uuid}"),
                :crowdsourcer_type => oc.crowdsourcer_type,
                :responded => !oc.hit_responses.where(:device_id => params[:device_id]).blank? }
      rescue Exception => e
        status = :internal_server_error
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end  
    end
    puts params.inspect
    render :json => (status == :ok ? hit.to_json : ''), :status => status
  end

  def get_responses
    status = :ok
    begin
      hit_responses = @hit.hit_responses
                          .joins(:device)
                          .order(:created_at)
                          .paginate(:page => params[:page], :per_page => 20)
                          .select("hit_responses.id, hit_responses.created_at, devices.uuid")
                          .collect{ |r| { :id => r.id,
                                          :created_at => r.created_at,
                                          :device_uuid => r.uuid } }
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end
    render :json => (status == :ok ? hit_responses.to_json : ''), :status => status
  end

  def get_response
    status = :ok
    return_data = {:sensor_data => []}
    hit_response = HitResponse.find(params[:response_id])
    if hit_response.nil?
      status = :bad_request
    else
      begin
        unless hit_response.sensing_response.nil?
          hit_response.sensing_response.sensing_response_items.each do |response_item|
            return_data[:sensor_data] << response_item.sensing_response_data.as_json.merge(:type => response_item.sensing_response_data_type)
          end
          return_data[:choice] = hit_response.hit_choice.description
        end
      rescue Exception => e
        status = :internal_server_error
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end
    end
    render :json => (status == :ok ? return_data.to_json : ''), :status => status
  end

  private
    def set_hit
      @hit = Hit.find(params[:id])
    end

    def hit_params
      params.require(:hit).permit(:crowdsourcer_id, :crowdsourcer_type, :question, :description, :sensing_data_type_ids => [])
    end
end
