class HitChoicesController < ApplicationController
  def new
    @hit = HumanIntelligenceTask.find(params[:human_intelligence_task_id].to_i)
    @hit_choice = HitChoice.new

    respond_to do |format|
      format.js { render }
    end
  end

  def edit
    @hit_choice = HitChoice.find(params[:id])
    respond_to do |format|
      format.js { render }
    end
  end

  def create
    @hit_choice = HitChoice.new(hit_choice_params)

    @hit_choice.save
    respond_to do |format|
      format.js { render }
    end
  end

  def update
    @hit_choice = HitChoice.find(params[:id])
    @hit_choice.update_attributes(hit_choice_params)

    @hit_choice.save
    respond_to do |format|
      format.js { render }
    end
  end

  def destroy
    @hit_choice = HitChoice.find(params[:id])
    @hit_choice.destroy

    respond_to do |format|
      format.js { render }
    end
  end

  private

    def hit_choice_params
      params.require(:hit_choice).permit(:human_intelligence_task_id, :description)
    end

end
