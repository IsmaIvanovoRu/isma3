class InternationalContractsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_international_contract, only: [:destroy]
  
  def destroy
    @international_contract.destroy
    redirect_to :back
  end
  
  def import
    InternationalContract.import(params[:file])
    redirect_to :back, notice: "Contracts imported."
  end
  
  private
  
  def set_international_contract
    @international_contract = InternationalContract.find(params[:id])
  end
end
