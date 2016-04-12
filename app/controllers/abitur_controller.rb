class AbiturController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    redirect_to article_path(8)
  end
end