class ArchivesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_action :set_articles
  def articles
    if current_user.nil?
      @articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['articles'], published: true, group_id: nil).paginate(:page => params[:page])
    else
      if current_user_moderator?
	current_user_groups = Group.all + [nil]
	@articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['articles'], group_id: current_user_groups).paginate(:page => params[:page])
      else
	current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
	@articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['articles'], group_id: current_user_groups, published: true).paginate(:page => params[:page])
      end
    end
  end

  def news
    if current_user.nil?
      @articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['news'], published: true, group_id: nil).paginate(:page => params[:page])
    else
      if current_user_moderator?
	current_user_groups = Group.all + [nil]
	@articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['news'], group_id: current_user_groups).paginate(:page => params[:page])
      else
	current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
	@articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['news'], group_id: current_user_groups, published: true).paginate(:page => params[:page])
      end
    end
  end

  def announcements
    if current_user.nil?
      @articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['announcements'], published: true, group_id: nil).paginate(:page => params[:page])
    else
      if current_user_moderator?
	current_user_groups = Group.all + [nil]
	@articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['announcements'], group_id: current_user_groups).paginate(:page => params[:page])
      else
	current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
	@articles = Article.includes(:attachments).order('updated_at DESC').where(id: @articles['announcements'], group_id: current_user_groups, published: true).paginate(:page => params[:page])
      end
    end
  end
  
  private
  
  def set_articles
      @articles = Article.includes(:article_type).group_by{|a| a.article_type.name}     
  end
end
