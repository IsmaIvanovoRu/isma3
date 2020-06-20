#encoding: UTF-8
class EducationalProgramPerevodsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_program_perevod, only: [:show, :edit, :destroy, :update]
  before_action :educational_program_perevod_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @educational_program_perevods = EducationalProgramPerevod.order("date ASC").load
  end
  
  def show
  end
  
  def new
    @educational_program_perevod = EducationalProgramPerevod.new
  end
  
  def create
    @educational_program_perevod = EducationalProgramPerevod.new(educational_program_perevod_params)
    if @educational_program_perevod.save!
      redirect_to @educational_program_perevod, notice: "New numbers added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @educational_program_perevod.update(educational_program_perevod_params)
      redirect_to @educational_program_perevod
    else
      render action 'edit'
    end
  end
  
  def destroy
    @educational_program_perevod.destroy
    redirect_to educational_program_perevods_url
  end
  
  def import
    EducationalProgramPerevod.import(params[:file])
    redirect_to educational_program_perevods_url, notice: "Numbers imported."
  end
  
  private
  
  def set_educational_program_perevod
    @educational_program_perevod = EducationalProgramPerevod.find(params[:id])
  end
  
  def educational_program_perevod_params
    params.require(:educational_program_perevod).permit(:id, :educational_program_id, :number_out_perevod, :number_to_perevod, :number_res_perevod, :number_exp_perevod, :date)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order(:name).load
  end
end
