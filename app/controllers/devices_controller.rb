require 'android_sensor_type'

class DevicesController < ApplicationController
  skip_before_filter :authenticate_account!, :only => [:register, :background_tracking]
  skip_before_filter :verify_authenticity_token, :only => [:register, :background_tracking], :if => Proc.new { |c| c.request.format == 'application/json' }
  load_and_authorize_resource :except => [:register, :background_tracking]

  def index
    @devices = Device.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 21)
  end

  def show
    @device = Device.find_by_id(params[:id])
  end

  def register
    begin
      device = Device.find_or_initialize_by(:uuid => params[:uuid])
      device.update_attributes!(device_params)
      device.sensors.delete_all
      params[:sensors].each do |sensor_params|
        device.sensors.create!( sensor_params.permit(:vendor, 
                                                    :name, 
                                                    :sensor_type, 
                                                    :version, 
                                                    :max_range, 
                                                    :power, 
                                                    :resolution) )
      end

      device.save!
      reg_info = { :reg_id => device.id }
      respond_to do |format|
        format.json { render :json => reg_info.to_json, :status => :ok }
      end      
    rescue Exception => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
      respond_to do |format|
        format.json { render :json => e.message.to_json, :status => :internal_server_error }
      end
    end
  end

  def unregister
    @device = Device.find_by_id(params[:id])
  end

  def destroy
    @device = Device.find_by_id(params[:id])
    password = params[:password]
    if current_account.valid_password?(password)
      if @device.destroy
        flash[:success] = "Device was successfuly unregistered from CrowdCloud!"
        redirect_to :action => :index
      else
        flash[:error] = "Unable to unregister selected device!"
        redirect_to :action => :unregister
      end
    else
      flash[:error] = "Incorrect password!"
      redirect_to :action => :unregister
    end
  end

  def compose_message
    @device = Device.find_by_id(params[:id])
  end

  def push_message
    @device = Device.find_by_id(params[:id])

    if params[:message][:title].blank? || params[:message][:body].blank?
      flash[:error] = "Message title and body can't be blank!"
    else
      flash[:success] = "Your message was successfully sent to device <b>#{@device.uuid}</b>!".html_safe
      options = { data: { title: params[:message][:title], message: params[:message][:body] } }
      response = GCM.send([@device.push_id], options)
    end
    render :action => :compose_message
  end

  def sensors
    @device = Device.find_by_id(params[:id])
    @sensors = @device.sensors
  end

  def responses
    @device = Device.find_by_id(params[:id])
  end

  def mobility_profile
    @device = Device.find_by_id(params[:id])
  end

  def statistics
    @device = Device.find_by_id(params[:id])
  end


  def background_tracking
    status = :ok
    begin
      @device = Device.find_by_id(params[:id])
      @device.background_tracks.create!( params[:location].permit( :bearing,
                                                                   :latitude,
                                                                   :longitude,
                                                                   :altitude,
                                                                   :accuracy,
                                                                   :speed,
                                                                   :recorded_at ))
    rescue Exception => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
      status = :internal_server_error
    end

    render :json => '', :status => status
  end

  private
    def device_params
      params.require(:device).permit(:id, :uuid, :push_id, :model, :version, :platform)
    end
end
