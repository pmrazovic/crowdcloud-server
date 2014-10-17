class ResponsesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create], :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :authenticate_account!, :only => [:create]
  load_and_authorize_resource :skip => [:create]
  def index
    @open_call = OpenCall.find(params[:open_call_id])
    @responses = @open_call.responses.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @open_call = OpenCall.find(params[:open_call_id])
    @response = Response.find(params[:id])    
  end

  def create
    status = :ok
    begin
      unless params[:response_items].blank?
        response = Response.create!(:open_call => OpenCall.find(params[:id]),
                                    :device => Device.where(:uuid => params[:device][:uuid]).first)

        params[:response_items].each do |item|
          new_response_data = item.keys.first.constantize.create!(item.values.first)
          response.response_items.create!(:response_data => new_response_data)
        end
      end
    rescue Exception => e
      status = :internal_server_error
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
    end

    render :json => '', :status => status
  end
end
