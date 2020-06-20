class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    redirect_to articles_path if user_signed_in?
  end
end
