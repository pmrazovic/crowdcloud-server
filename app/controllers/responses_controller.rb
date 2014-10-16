class ResponsesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create], :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :authenticate_account!, :only => [:create]
  def index
    @open_call = OpenCall.find(params[:open_call_id])
    @responses = @open_call.responses
  end

  def show
    @open_call = OpenCall.find(params[:open_call_id])
    @response = Response.find(params[:id])    
  end

  def create
    status = :ok
    begin
      response = Response.create!(:open_call => OpenCall.find(params[:id]),
                                 :device => Device.where(:uuid => params[:device][:uuid]).first)

      params[:response_items].each do |item|
        new_response_data = item.keys.first.constantize.create!(item.values.first)
        response.response_items.create!(:response_data => new_response_data)
      end
    rescue Exception => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
      status = :internal_server_error
    end

    render :json => '', :status => status
  end
end
