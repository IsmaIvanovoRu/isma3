class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_action :current_user
  before_action :set_permissions
  before_action :set_menus
  before_action :profile_empty?
  before_action :set_alert
  before_action :set_details

  def require_reader
    unless current_user_reader?
      flash[:error] = "You mast have readers`s permissions"
      redirect_to root_path
    end
  end
  
  def require_writer
    unless current_user_writer?
      flash[:error] = "You mast have writer`s permissions"
      redirect_to root_path
    end
  end
  
  def require_moderator
    unless current_user_moderator?
      flash[:error] = "You mast have moderator`s permissions"
      redirect_to root_path
    end
  end 
  
  def require_administrator
    unless current_user_administrator?
      flash[:error] = "You mast have administrator`s permissions"
      redirect_to root_path
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
  
  def set_menus
    if current_user_administrator? 
      @menus = Menu.order(:weigth).load.group_by(&:location)
      @parent_menus = Menu.all
      @url = request.fullpath
      @menu_title = ""
    else
      @menus = Menu.order(:weigth).where(private: false).group_by(&:location)
    end
      @down_block_count = 12/@menus['down'].group_by(&:parent_id).first.last.count if @menus['down']
      @menu = Menu.new
  end
  
  def profile_empty?
    current_user.profile.full_name.empty? if current_user
  end
  
  def set_alert
    flash[:error] ||= nil
    flash[:alert] ||= nil
    case
      when profile_empty?
	flash[:alert] = "Your profile is empty"
    end
  end
  
  def set_permissions
    @administrator_permission = current_user_administrator?
    @moderator_permission = current_user_moderator?
    @writer_permission = current_user_writer?
  end
  
  def set_details
    @details_hash = Hash.new
    Detail.all.each{|d| @details_hash[d.key] = d.value}
    @details_hash
  end
end

