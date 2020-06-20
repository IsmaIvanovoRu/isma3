class Events < ActionMailer::Base
  helper ApplicationHelper
  default from: "it@isma.ivanovo.ru"
  
  def new_article(article_id)
    @article = Article.find(article_id)
    mail(to: 'webmaster@isma.ivanovo.ru', subject: t(:you_have_a_new_article, scope: :notices))
  end
  
  def new_feedback(feedback_id)
    @feedback = Feedback.find(feedback_id)
    mail(to: 'webmaster@isma.ivanovo.ru', subject: t(:there_is_a_new_feedback, scope: :notices))
  end
  
  def assign_feedback(feedback_id)
    @feedback = Feedback.find(feedback_id)
    mail(to: (@feedback.post.division.email if @feedback.post.division.email), subject: t(:there_is_a_new_feedback, scope: :notices))
  end
end
