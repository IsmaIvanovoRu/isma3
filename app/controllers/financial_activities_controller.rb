class FinancialActivitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_financial_activity, only: [:show, :edit, :destroy, :update]
  before_action :financial_activity_params, only: [:create, :update]
  
  def index
    @financial_activities = FinancialActivity.order("year ASC").load
  end
  
  def show
  end
  
  def new
    @financial_activity = FinancialActivity.new
  end
  
  def create
    @financial_activity = FinancialActivity.new(financial_activity_params)
    if @financial_activity.save!
      redirect_to @financial_activity, notice: "New financial activity added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @financial_activity.update(financial_activity_params)
      redirect_to @financial_activity
    else
      render action 'edit'
    end
  end
  
  def destroy
    @financial_activity.destroy
    redirect_to financial_activities_url
  end
  
  private
  
  def set_financial_activity
    @financial_activity = FinancialActivity.find(params[:id])
  end
  
  def financial_activity_params
    params.require(:financial_activity).permit(:id, :year, :federal_volume, :regiional_volume, :municipal_volume, :personal_volume, :financial_report_link, :financial_plan_link, :bus_gov_link)
  end
end
