class SensingResponsesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create], :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :authenticate_account!, :only => [:create]
  load_and_authorize_resource :except => [:create]
  def index
    @sensing_task = SensingTask.find(params[:sensing_task_id])
    @sensing_responses = @sensing_task.sensing_responses.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @sensing_task = SensingTask.find(params[:sensing_task_id])
    @sensing_response = SensingResponse.find(params[:id])    
  end

  def create
    status = :ok
    begin
      unless params[:response_items].blank?
        sensing_response = SensingResponse.create!(:task_id => params[:task_id],
                                                   :task_type => params[:task_type],
                                                   :device => Device.where(:uuid => params[:device][:uuid]).first)

        params[:response_items].each do |item|
          new_response_data = item.keys.first.constantize.create!(item.values.first)
          sensing_response.sensing_response_items.create!(:sensing_response_data => new_response_data)
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
