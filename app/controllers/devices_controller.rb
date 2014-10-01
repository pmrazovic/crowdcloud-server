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
    new_device = Device.new( :uuid => params[:uuid],
                             :platform => params[:platform],
                             :model => params[:model],
                             :version => params[:version],
                             :name => params[:name],
                             :push_id => params[:push_id] )

    respond_to do |format|
      format.json { render :json => "", :status => (new_device.save ? :ok : :internal_server_error)  }
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
    notification = {
      :schedule_for => [Time.now],
      :apids => [@device.push_id],
      :android => {:alert => "Test message"}
    }

    Urbanairship.push(notification)

    redirect_to :action => :index
  end
end
