#encoding: UTF-8
class EducationalProgramResearchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_educational_program_research, only: [:show, :edit, :destroy, :update]
  before_action :educational_program_research_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @educational_program_researches = EducationalProgramResearch.order("date ASC").load
  end
  
  def show
  end
  
  def new
    @educational_program_research = EducationalProgramResearch.new
  end
  
  def create
    @educational_program_research = EducationalProgramResearch.new(educational_program_research_params)
    if @educational_program_research.save!
      redirect_to @educational_program_research, notice: "New researches added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @educational_program_research.update(educational_program_research_params)
      redirect_to educational_program_researches_url
    else
      render action 'edit'
    end
  end
  
  def destroy
    @educational_program_research.destroy
    redirect_to educational_program_researches_url
  end
  
  def import
    EducationalProgramResearch.import(params[:file])
    redirect_to educational_program_researches_url, notice: "Researchs imported."
  end
  
  private
  
  def set_educational_program_research
    @educational_program_research = EducationalProgramResearch.find(params[:id])
  end
  
  def educational_program_research_params
    params.require(:educational_program_research).permit(:id, :educational_program_id, :perechen_nir, :base_nir, :date, :npr_nir, :stud_nir, :monograf_nir, :article_nir, :patent_r_nir, :patent_z_nir, :svid_r_nir, :svid_z_nir, :finance_nir)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order('level DESC').order([:code, :name])
  end
end
