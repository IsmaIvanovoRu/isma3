class MarksController < ApplicationController
  before_action :set_mark, only: [:edit, :update, :destroy, :mark_owner?]
  before_action :can, only: [:edit, :update, :destroy]

  def edit
  end
  
  def update
    if @mark.update(mark_params)
      redirect_to user_profile_path(@mark.user)
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @mark.destroy
    redirect_to :back
  end
  
  def import
    Mark.import(params[:file])
    redirect_to users_url, notice: "Marks imported."
  end
  
  def report
  end

  private

  def set_mark
    @mark = Mark.find(params[:id])
  end
  
  def mark_params
    params.require(:mark).permit(:user_id, :educational_program_id, :subject, :value)
  end
  
  def can?
    current_user_administrator? || mark_owner?
  end
  
  def can
    unless can?
      flash[:error] = "You must have permissions"
      redirect_to root_path
    else
      @can = true
    end
  end
  
  def mark_owner?
    @mark.user == current_user
  end
end
