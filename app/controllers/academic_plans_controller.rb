class AcademicPlansController < ApplicationController
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_academic_plan, only: [:show, :edit, :destroy, :update]
  before_action :academic_plan_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @academic_plans = AcademicPlan.order(:name).load
  end
  
  def show
    
  end
  
  def new
    @academic_plan = AcademicPlan.new
  end
  
  def create
    @academic_plan = AcademicPlan.new(academic_plan_params)
    if @academic_plan.save!
      redirect_to @academic_plan, notice: "New academic_plan added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @academic_plan.update(academic_plan_params)
      redirect_to @academic_plan
    else
      render action 'edit'
    end
  end
  
  def destroy
    @academic_plan.destroy
    redirect_to academic_plans_url
  end
  
  private
  
  def set_academic_plan
    @academic_plan = AcademicPlan.find(params[:id])
  end
  
  def academic_plan_params
    params.require(:academic_plan).permit(:id, :name, :educational_program_id, :attachment_id)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order(:level, :name).load
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /pdf/}
  end
end