class AcademicSchedulesController < ApplicationController
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_academic_schedule, only: [:show, :edit, :destroy, :update]
  before_action :academic_schedule_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @academic_schedules = AcademicSchedule.order(:name).load
  end
  
  def show
    
  end
  
  def new
    @academic_schedule = AcademicSchedule.new
  end
  
  def create
    @academic_schedule = AcademicSchedule.new(academic_schedule_params)
    if @academic_schedule.save!
      redirect_to @academic_schedule, notice: "New academic_schedule added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @academic_schedule.update(academic_schedule_params)
      redirect_to @academic_schedule
    else
      render action 'edit'
    end
  end
  
  def destroy
    @academic_schedule.destroy
    redirect_to academic_schedules_url
  end
  
  private
  
  def set_academic_schedule
    @academic_schedule = AcademicSchedule.find(params[:id])
  end
  
  def academic_schedule_params
    params.require(:academic_schedule).permit(:id, :name, :educational_program_id, :attachment_id)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order(:level, :name).load
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /pdf/}
  end
end