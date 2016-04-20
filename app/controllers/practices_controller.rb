class PracticesController < ApplicationController
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_practice, only: [:show, :edit, :destroy, :update]
  before_action :practice_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @practices = Practice.order(:name).load
  end
  
  def show
    
  end
  
  def new
    @practice = Practice.new
  end
  
  def create
    @practice = Practice.new(practice_params)
    if @practice.save!
      redirect_to @practice, notice: "New practice added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @practice.update(practice_params)
      redirect_to @practice
    else
      render action 'edit'
    end
  end
  
  def destroy
    @practice.destroy
    redirect_to practices_url
  end
  
  private
  
  def set_practice
    @practice = Practice.find(params[:id])
  end
  
  def practice_params
    params.require(:practice).permit(:id, :name, :educational_program_id, :attachment_id)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order(:level, :name).load
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /Практи|практи/}
  end
end