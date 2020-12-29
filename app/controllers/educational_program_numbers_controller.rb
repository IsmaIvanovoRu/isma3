#encoding: UTF-8
class EducationalProgramNumbersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_program_number, only: [:show, :edit, :destroy, :update]
  before_action :educational_program_number_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @educational_program_numbers = EducationalProgramNumber.order("date ASC").load
  end
  
  def show
  end
  
  def new
    @educational_program_number = EducationalProgramNumber.new
  end
  
  def create
    @educational_program_number = EducationalProgramNumber.new(educational_program_number_params)
    if @educational_program_number.save!
      redirect_to @educational_program_number, notice: "New numbers added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @educational_program_number.update(educational_program_number_params)
      redirect_to @educational_program_number
    else
      render action 'edit'
    end
  end
  
  def destroy
    @educational_program_number.destroy
    redirect_to educational_program_numbers_url
  end
  
  def import
    EducationalProgramNumber.import(params[:file])
    redirect_to educational_program_numbers_url, notice: "Numbers imported."
  end
  
  private
  
  def set_educational_program_number
    @educational_program_number = EducationalProgramNumber.find(params[:id])
  end
  
  def educational_program_number_params
    params.require(:educational_program_number).permit(:id, :educational_program_id, :number_federal, :number_regional, :number_local, :number_personal, :number_foreign, :date)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order('level DESC').order([:code, :name])
  end
end
