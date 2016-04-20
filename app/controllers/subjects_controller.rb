class SubjectsController < ApplicationController
  before_action :require_moderator, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_subject, only: [:show, :edit, :destroy, :update]
  before_action :subject_params, only: [:create, :update]
  before_action :options_for_select, only: [:new, :edit]
  
  def index
    @subjects = Subject.order(:name).load
  end
  
  def show
    
  end
  
  def new
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(subject_params)
    if @subject.save!
      redirect_to @subject, notice: "New subject added successfully"
    else
      render action 'new'
    end
  end
  
  def update
    if @subject.update(subject_params)
      redirect_to @subject
    else
      render action 'edit'
    end
  end
  
  def destroy
    @subject.destroy
    redirect_to subjects_url
  end
  
  private
  
  def set_subject
    @subject = Subject.find(params[:id])
  end
  
  def subject_params
    params.require(:subject).permit(:id, :name, :educational_program_id, :attachment_id)
  end
  
  def options_for_select
    @educational_programs = EducationalProgram.order(:level, :name).load
    @attachments = Attachment.order(:title).select(:id, :title).select{|a| a.title =~ /.pdf/}
  end
end