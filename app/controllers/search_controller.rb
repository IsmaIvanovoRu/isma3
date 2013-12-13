class SearchController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    @search = ThinkingSphinx.search params[:search], :page => params[:page], :per_page => 30
  end
end