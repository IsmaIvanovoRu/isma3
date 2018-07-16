class EntrantsController < ApplicationController
  skip_before_filter :authenticate_user!
  def new
    
  end
end
