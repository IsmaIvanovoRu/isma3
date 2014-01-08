class ArchivesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_action :set_articles
  def articles
    @articles = Article.where(id: @articles['articles']).paginate(:page => params[:page])
  end

  def news
    @articles = Article.where(id: @articles['news']).paginate(:page => params[:page])
  end

  def announcements
    @articles = Article.where(id: @articles['announcements']).paginate(:page => params[:page])
  end
  
  private
  
  def set_articles
    if current_user.nil?
      @articles = Article.includes(:attachments).order('updated_at DESC').includes(:article_type).where(published: true, group_id: nil).group_by{|a| a.article_type.name}     
    else
      current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
      @articles = Article.includes(:attachments).order('updated_at DESC').includes(:article_type).where(published: true, group_id: current_user_groups).group_by{|a| a.article_type.name} 
    end
  end
end
