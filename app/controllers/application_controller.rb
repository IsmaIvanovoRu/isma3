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
  before_action :feedbacks_count
  before_filter :current_user_moderator?
  before_action :articles_count
  before_action :new_comments

  def require_reader
    unless current_user_reader?
      flash[:error] = "You must have readers`s permissions"
      redirect_to root_path
    end
  end
  
  def require_writer
    unless current_user_writer?
      flash[:error] = "You must have writer`s permissions"
      redirect_to root_path
    end
  end
  
  def require_moderator
    unless current_user_moderator?
      flash[:error] = "You must have moderator`s permissions"
      redirect_to root_path
    end
  end 
  
  def require_administrator
    unless current_user_administrator?
      flash[:error] = "You must have administrator`s permissions"
      redirect_to root_path
    end
  end 

  def require_commentator
    unless current_user_commentator?
      flash[:error] = "You must have commentator`s permissions"
      redirect_to root_path
    end
  end 
  
  def current_user_groups
    current_user.groups
  end
  
  def current_user_writer?
    current_user_groups.where(writer: true).count > 0 unless current_user.nil?
  end
  
  def current_user_moderator?
    current_user_groups.where(moderator: true).count > 0 unless current_user.nil?
  end

  def current_user_commentator?
    current_user_groups.where(commentator: true).count > 0 unless current_user.nil?
  end

  def current_user_administrator?
    current_user_groups.where(administrator: true).count > 0 unless current_user.nil?
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
	flash[:alert] = t(:your_profile_is_empty, scope: :notices)
    end
  end
  
  def set_permissions
    @administrator_permission = current_user_administrator?
    @moderator_permission = current_user_moderator?
    @writer_permission = current_user_writer?
    @commentator_permission = current_user_commentator?
  end
  
  def set_details
    @details_hash = Hash.new
    Detail.all.each{|d| @details_hash[d.key] = d.value}
    @details_hash
  end
  
  def feedbacks_count
    @feedbacks_count = @moderator_permission ? Feedback.where(public: false).count : (Feedback.joins(:user).where(public: false, users: {id: current_user}).count unless current_user.nil?)
  end
  
  def articles_count
   @articles_count = Article.order('updated_at DESC').where(published: false).count || 0 if @moderator_permission
  end
  
  def new_comments
    @new_comments = Article.includes(:comments).joins(:comments).where(comments: {published: false}).uniq if @moderator_permission
  end
end

