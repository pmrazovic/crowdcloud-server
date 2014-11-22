class HitResponsesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create], :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :authenticate_account!, :only => [:create]
  load_and_authorize_resource :except => [:create]

  def create
    status = :ok
    begin
      hit_response = HitResponse.create!(:hit_id => params[:task_id],
                                         :device => Device.where(:uuid => params[:device][:uuid]).first,
                                         :hit_choice_id => params[:choice_id])

      unless params[:sensing_response_items].blank?
        sensing_response = SensingResponse.create!(:sensable_id => hit_response.id,
                                                   :sensable_type => "HitResponse",
                                                   :device => hit_response.device)

        params[:sensing_response_items].each do |item|
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
