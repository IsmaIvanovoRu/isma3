class EducationalStandartsController < ApplicationController
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_standart, only: [:show, :edit, :destroy, :update]
  before_action :educational_standart_params, only: [:create, :update]
  
  def index
    @educational_standarts = EducationalStandart.order(:level, :name).load
  end
  
  def show
    
  end
  
  def new
    @educational_standart = EducationalStandart.new
  end
  
  def create
    @educational_standart = EducationalStandart.new(educational_standart_params)
    if @educational_standart.save!
      redirect_to @educational_standart, notice: "New standart added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @educational_standart.update(educational_standart_params)
      redirect_to @educational_standart
    else
      render action 'edit'
    end
  end
  
  def destroy
    @educational_standart.destroy
    redirect_to educational_standarts_url
  end
  
  private
  
  def set_educational_standart
    @educational_standart = EducationalStandart.find(params[:id])
  end
  
  def educational_standart_params
    params.require(:educational_standart).permit(:id, :name, :level, :url)
  end
end