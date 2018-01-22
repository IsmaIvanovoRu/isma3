#encoding: UTF-8
class EducationalProgramPriemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_program_priem, only: [:show, :edit, :destroy, :update]
  before_action :educational_program_priem_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @educational_program_priems = EducationalProgramPriem.order("date ASC").load
  end
  
  def show
  end
  
  def new
    @educational_program_priem = EducationalProgramPriem.new
  end
  
  def create
    @educational_program_priem = EducationalProgramPriem.new(educational_program_priem_params)
    if @educational_program_priem.save!
      redirect_to @educational_program_priem, notice: "New numbers added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @educational_program_priem.update(educational_program_priem_params)
      redirect_to @educational_program_priem
    else
      render action 'edit'
    end
  end
  
  def destroy
    @educational_program_priem.destroy
    redirect_to educational_program_priems_url
  end
  
  def import
    EducationalProgramPriem.import(params[:file])
    redirect_to educational_program_priems_url, notice: "Numbers imported."
  end
  
  private
  
  def set_educational_program_priem
    @educational_program_priem = EducationalProgramPriem.find(params[:id])
  end
  
  def educational_program_priem_params
    params.require(:educational_program_priem).permit(:id, :educational_program_id, :number_federal, :number_regional, :number_local, :number_personal, :date, :summa)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order(:name).load
  end
end
