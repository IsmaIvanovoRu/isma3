class ClassroomsController < ApplicationController
  before_filter :require_moderator
  def index
    @classrooms = Classroom.includes(:subject).order(:description)
  end
  
  def destroy
    @classroom = Classroom.find(params[:id])
    @classroom.destroy
    redirect_to classrooms_url, notice: 'Classroom deleted'
  end
  
  def import
    Classroom.import(params[:file])
    redirect_to classrooms_url, notice: 'Classrooms imported'
  end
end
