class AccreditationsController < ApplicationController
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_accreditation, only: [:show, :edit, :destroy, :update]
  before_action :accreditation_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @accreditations = Accreditation.order(:date_of_issue).load
  end
  
  def show
    
  end
  
  def new
    @accreditation = Accreditation.new
  end
  
  def create
    @accreditation = Accreditation.new(accreditation_params)
    if @accreditation.save!
      redirect_to @accreditation, notice: "New accreditation added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @accreditation.update(accreditation_params)
      redirect_to @accreditation
    else
      render action 'edit'
    end
  end
  
  def destroy
    @accreditation.destroy
    redirect_to accreditations_url
  end
  
  private
  
  def set_accreditation
    @accreditation = Accreditation.find(params[:id])
  end
  
  def accreditation_params
    params.require(:accreditation).permit(:id, :number, :date_of_issue, :expiration_date, :attachment_id)
  end
  
  def options_for_select
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /аккредитации/}
  end
end