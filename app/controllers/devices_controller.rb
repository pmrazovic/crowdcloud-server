class DevicesController < ApplicationController
  before_filter :authenticate_account!, :only => [:index]
  skip_before_filter :verify_authenticity_token, :only => [:register], :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @devices = Device.all
  end

  def show
    @device = Device.find_by_id(params[:id])
  end

  def register
    device = Device.find_or_initialize_by(:uuid => params[:uuid])
    device.update_attributes(device_parameters)

    respond_to do |format|
      if device.save
        reg_info = { :reg_id => device.id }
        format.json { render :json => reg_info.to_json, :status => :ok }
      else
        format.json { render :json => "", :status => :internal_server_error }
      end
    end
  end

  def unregister
    @device = Device.find_by_id(params[:id])
    if @device.destroy
      flash[:success] = "Device was successfuly unregistered from CrowdCloud!"
    else
      flash[:error] = "Unable to unregister selected device!"
    end
    redirect_to :action => :index
  end

  def push_message
    @device = Device.find_by_id(params[:id])

    options = {data: {title: "Test message", message: "CrowdCloud server test"}}
    response = GCM.send([@device.push_id], options)

    redirect_to :action => :index
  end

  private
    def device_parameters
      params.require(:device).permit(:uuid, :push_id, :model, :version, :platform, :name)
    end

end
