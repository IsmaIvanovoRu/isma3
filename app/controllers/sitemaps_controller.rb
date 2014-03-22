class SitemapsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :current_user
  skip_before_filter :set_permissions
  skip_before_filter :set_menus
  skip_before_filter :profile_empty?
  skip_before_filter :set_alert
  skip_before_filter :set_details
  skip_before_filter :feedbacks_count
  skip_before_filter :articles_count
  def sitemap
    @articles = Article.select("id, updated_at").where(group_id: nil)
    @divisions = Division.select("id, updated_at")
    @posts = Post.select("posts.id, posts.updated_at, division_id").includes(:division).joins(:division)
    @profiles = Profile.select("profiles.id, profiles.updated_at, user_id").includes(:user).joins(:user)
    @attachments = Attachment.select("attachments.id, attachments.updated_at").joins(:articles).where(articles: {group_id: nil})
    respond_to do |format|
      format.xml
    end
  end
end
