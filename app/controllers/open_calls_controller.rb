require 'open_call_status'
class OpenCallsController < ApplicationController
  before_action :set_open_call, only: [:show, :edit, :update, :destroy]

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

  private
    def set_open_call
      @open_call = OpenCall.find(params[:id])
    end

    def open_call_params
      params.require(:open_call).permit(:account_id, :name, :description, :response_data_type_ids => [])
    end
end
