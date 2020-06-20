#encoding: UTF-8
class EducationalProgramVacantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_program_vacant, only: [:show, :edit, :destroy, :update]
  before_action :educational_program_vacant_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @educational_program_vacants = EducationalProgramVacant.order("date ASC").load
  end
  
  def show
  end
  
  def new
    @educational_program_vacant = EducationalProgramVacant.new
  end
  
  def create
    @educational_program_vacant = EducationalProgramVacant.new(educational_program_vacant_params)
    if @educational_program_vacant.save!
      redirect_to @educational_program_vacant, notice: "New vacants added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @educational_program_vacant.update(educational_program_vacant_params)
      redirect_to @educational_program_vacant
    else
      render action 'edit'
    end
  end
  
  def destroy
    @educational_program_vacant.destroy
    redirect_to educational_program_vacants_url
  end
  
  def import
    EducationalProgramVacant.import(params[:file])
    redirect_to educational_program_vacants_url, notice: "Vacants imported."
  end
  
  private
  
  def set_educational_program_vacant
    @educational_program_vacant = EducationalProgramVacant.find(params[:id])
  end
  
  def educational_program_vacant_params
    params.require(:educational_program_vacant).permit(:id, :educational_program_id, :stage, :number_federal, :number_regional, :number_local, :number_personal, :date)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order('level DESC').order([:code, :name])
  end
end
