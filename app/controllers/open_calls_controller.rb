require 'open_call_status'
class OpenCallsController < ApplicationController
  before_action :set_open_call, only: [:show, :edit, :update, :destroy, :delete, :confirm_publish ,:publish, :responses, :devices]
  skip_before_filter :authenticate_account!, :only => [:list_open_calls, :get_open_call]
  load_and_authorize_resource :skip => [:list_open_calls, :get_open_call]
  skip_before_filter :verify_authenticity_token, :only => [:list_open_calls], :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @open_calls = OpenCall.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def show
  end

  def new
    @open_call = OpenCall.new
  end

  def edit
  end

  def create
    @open_call = OpenCall.new(open_call_params)

    respond_to do |format|
      if @open_call.save
        format.html { redirect_to @open_call, notice: 'Open call was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      unless params[:open_call].has_key?(:response_data_type_ids)
        params[:open_call][:response_data_type_ids] = []
      end
      if @open_call.update(open_call_params)
        format.html { redirect_to @open_call, notice: 'Open call was successfully updated.' }
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
      if @open_call.destroy
        flash[:success] = "Open call was successfuly removed from CrowdCloud!"
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
    # push_ids = @open_call.devices.collect{|op| op.push_id}
    @open_call.status = OpenCallStatus::PUBLISHED.to_s
    @open_call.published_at = Time.now
    @open_call.save
    push_ids = Device.all.collect{|d| d.push_id}
    options = {:data => { :title => "Open call: #{@open_call.name}", 
                          :message => "New open call has been posted",
                          :open_call => { :id => @open_call.id,
                                          :name => @open_call.name,
                                          :description => @open_call.description,
                                          :published_at => @open_call.published_at,
                                          :response_data_types => @open_call.response_data_types.collect{ |type| type.name } } }}

    gcm_response = GCM.send(push_ids, options)
    respond_to do |format|
      format.html { redirect_to @open_call, notice: 'Open call is successfully published.' }
    end
  end

  def devices
  end

  # Open Calls Api -------------------

  def list_open_calls
    open_calls = OpenCall.where(:status => OpenCallStatus::PUBLISHED.to_s)
                         .order("created_at DESC")
                         .paginate(:page => params[:page], :per_page => 20)
                         .collect{ |oc| { :id => oc.id, 
                                          :name => oc.name,
                                          :published_at => oc.published_at,
                                          :crowdsourcer => oc.account.email,
                                          :responded => Response.exists?(:open_call_id => oc.id, :device_id => params[:device_id]) }
                                  }
    render :json => open_calls.to_json
  end

  def get_open_call
    oc = OpenCall.find(params[:id])
    open_call = { :id => oc.id, 
                  :name => oc.name,
                  :description => oc.description,
                  :created_at => oc.created_at,
                  :published_at => oc.published_at,
                  :response_data_types => oc.response_data_types.collect{ |t| t.name },
                  :crowdsourcer => oc.account.email,
                  :responded => Response.exists?(:open_call_id => oc.id, :device_id => params[:device_id]) }

    puts params.inspect
    render :json => open_call.to_json
  end

  private
    def set_open_call
      @open_call = OpenCall.find(params[:id])
    end

    def open_call_params
      params.require(:open_call).permit(:account_id, :name, :description, :response_data_type_ids => [])
    end
end
