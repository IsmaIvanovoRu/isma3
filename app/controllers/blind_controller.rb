class BlindController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def common
    session[:blind] = false
    redirect_to :back
  end
  
  def special
    session[:blind] = true
    request.env["HTTP_REFERER"] ? redirect_to(:back) : redirect_to(root_path)
  end
end