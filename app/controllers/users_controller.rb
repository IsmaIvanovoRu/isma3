class UsersController < ApplicationController
  before_action :current_user_administrator?
  before_action :set_user, only: [:show, :destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end
  
  def destroy
    @user.destroy
    redirect_to :root
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end
end
