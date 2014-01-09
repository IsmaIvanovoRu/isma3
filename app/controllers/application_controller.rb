class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_action :current_user
  before_action :set_menu_and_path
  before_action :set_menus
  before_action :profile_empty?
  before_action :set_alert

  def require_reader
    unless current_user_reader?
      flash[:error] = "You mast have readers`s permissions"
      redirect_to :back
    end
  end
  
  def require_writer
    unless current_user_writer?
      flash[:error] = "You mast have writer`s permissions"
      redirect_to :back
    end
  end
  
  def require_moderator
    unless current_user_moderator?
      flash[:error] = "You mast have moderator`s permissions"
      redirect_to :back
    end
  end 
  
  def require_administrator
    unless current_user_administrator?
      flash[:error] = "You mast have administrator`s permissions"
      redirect_to :back
    end
  end 
  
  def current_user_writer?
    current_user.groups.where(writer: true).count > 0 unless current_user.nil?
  end
  
  def current_user_moderator?
    current_user.groups.where(moderator: true).count > 0 unless current_user.nil?
  end

  def current_user_commentator?
    current_user.groups.where(commentator: true).count > 0 unless current_user.nil?
  end

  def current_user_administrator?
    current_user.groups.where(administrator: true).count > 0 unless current_user.nil?
  end
  
  def set_menu_and_path
    @menu = Menu.new
    @url = request.path
  end
  
  def set_menus
    if current_user_administrator? 
      @menus = Menu.order(:weigth).load.group_by(&:location) 
      @parent_menus = Menu.where(parent_id: nil)
    else
      @menus = Menu.order(:weigth).where(private: false).group_by(&:location) 
      @parent_menus = Menu.where(parent_id: nil, private: false)
    end
      @url = request.fullpath
  end
  
  def profile_empty?
    current_user.profile.full_name == "" if current_user
  end
  
  def set_alert
    case
      when profile_empty?
	flash[:alert] = "Your profile is empty"
      else 
	flash[:alert]=  ""
    end
  end
end

