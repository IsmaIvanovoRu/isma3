class CriteriaController < ApplicationController
  before_action :require_administrator
  before_action :set_criterium, only: [:show, :edit, :update,:destroy]

  def index
    @criteria = Criterium.order(:chapter)
  end

  def destroy
    @criterium.destroy
    redirect_to :back
  end
  
  def import
    Criterium.import(params[:file])
    redirect_to :back, notice: "Criteria imported."
  end

  private

  def set_criterium
    @criterium = Criterium.find(params[:id])
  end
end