class BlindController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def common
    session[:blind] = false
    redirect_to :back
  end
  
  def special
    session[:blind] = true
    redirect_to :back
  end
end