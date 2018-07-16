class ClassroomsController < ApplicationController
  before_filter :require_moderator, only: [:index, :import]
  def index
    @classrooms = Classroom.order(:description)
  end
  
  def import
    Classroom.import(params[:file])
    redirect_to classrooms_url, notice: 'Classrooms imported'
  end
end
