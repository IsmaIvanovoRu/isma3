class AbiturController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    redirect_to division_path(88)
  end
end