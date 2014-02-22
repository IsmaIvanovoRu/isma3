class Events < ActionMailer::Base
  default from: "it@isma.ivanovo.ru"
  
  def new_article(article)
    @article = article
    mail(to: 'markovnin@isma.ivanovo.ru', subject: 'You have a new article')
  end
  
  def new_feedback(feedback)
    @feedback = feedback
    mail(to: 'markovnin@isma.ivanovo.ru', subject: 'There is a new feedback')
  end
end
