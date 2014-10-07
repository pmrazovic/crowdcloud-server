require 'open_call_status'
class OpenCallsController < ApplicationController
  before_action :set_open_call, only: [:show, :edit, :update, :destroy, :publish]

  def index
    @open_calls = OpenCall.all
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
      if @open_call.update(open_call_params)
        format.html { redirect_to @open_call, notice: 'Open call was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @open_call.destroy
    respond_to do |format|
      format.html { redirect_to open_calls_url, notice: 'Open call was successfully destroyed.' }
    end
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

  private
    def set_open_call
      @open_call = OpenCall.find(params[:id])
    end

    def open_call_params
      params.require(:open_call).permit(:account_id, :name, :description, :response_data_type_ids => [])
    end
end
