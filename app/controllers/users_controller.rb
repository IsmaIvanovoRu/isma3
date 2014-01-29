class UsersController < ApplicationController
  before_action :require_administrator
  before_action :set_user, only: [:show, :destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end
end
