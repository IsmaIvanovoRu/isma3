#encoding: UTF-8
class EducationalProgramsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_program, only: [:show, :edit, :destroy, :update]
  before_action :educational_program_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit, :update]
  
  def index
    @educational_programs = EducationalProgram.order('level DESC').order([:code, :name])
  end
  
  def show
    @methodological_supports = @educational_program.methodological_supports.includes(:attachment).sort_by{|ms| ms.attachment.title}
    @subjects = @educational_program.subjects.order(:name)
    @methodological_support = MethodologicalSupport.new
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /pdf/}
  end
  
  def new
    @educational_program = EducationalProgram.new
  end
  
  def create
    @educational_program = EducationalProgram.new(educational_program_params)
    if @educational_program.save!
      redirect_to @educational_program, notice: "New program added successfully"
    else
      render action: 'new'
    end
  end
  
  def update
    if @educational_program.update(educational_program_params)
      redirect_to @educational_program
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @educational_program.toggle!(:active) if @educational_program.active
    redirect_to educational_programs_url
  end
  
  private
  
  def set_educational_program
    @educational_program = EducationalProgram.find(params[:id])
  end
  
  def educational_program_params
    params.require(:educational_program).permit(:id, :name, :code, :level, :form, :duration, :educational_standart_id, :accreditation_id, :attachment_id, :active, :language, :adaptive)
  end
  
  def options_for_select
    @educational_standarts = EducationalStandart.order(:level, :name).load
    @accreditations = Accreditation.order('date_of_issue DESC').load
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /pdf/}
  end
end
