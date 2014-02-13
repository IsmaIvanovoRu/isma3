module FeedbacksHelper
  def can_edit?
    Post.joins(:user).where(feedback: true, users: {id: current_user}).present? unless current_user.nil?
  end
end