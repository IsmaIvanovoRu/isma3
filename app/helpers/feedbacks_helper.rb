module FeedbacksHelper
  def can_edit?(feedback)
    Post.joins(:user).where(users: {id: current_user}).map(&:id).include?(feedback.to) unless current_user.nil?
  end
end