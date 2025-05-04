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
    if @educational_program.employee_list_id.present?
      @employees_educational_programs = nil
    else
      @employees_educational_programs = Profile.includes([:user, :degree, :academic_title]).joins(:divisions).where(divisions: {division_type_id: 3})
    end
    @posts_hash = {}
    Post.includes(:profile, :division).joins(:profile, :division).where(profiles: {id: @employees_educational_programs}).where(divisions: {division_type_id: 3}).group_by(&:user_id).each do |k, v|
      @posts_hash[k] = {}
      @posts_hash[k][:posts] = {}
      @posts_hash[k][:posts] = v.map{|p| [p.name, p.division.name].join(' ')}.each{|item| (item =~ /заведую/ ? item.gsub!('кафедра', '') : item.gsub!('кафедра', 'кафедры'))}.join(', ')
    end
    @methodological_supports = @educational_program.methodological_supports.includes(:attachment).sort_by{|ms| ms.attachment.title}
    @subjects = @educational_program.subjects.order(:name)
    @methodological_support = MethodologicalSupport.new
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /методические материалы|методические рекомендации|календарный план|программа воспитания/i}
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
    params.require(:educational_program).permit(:id, :name, :code, :level, :form, :duration, :educational_standart_id, :accreditation_id, :attachment_id, :active, :language, :adaptive, :year_start, :employee_list_id)
  end
  
  def options_for_select
    @educational_standarts = EducationalStandart.order(:level, :name).load
    @accreditations = Accreditation.order('date_of_issue DESC').load
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /ОП/}
    @nprs = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /сведения по НПР/}
  end
end