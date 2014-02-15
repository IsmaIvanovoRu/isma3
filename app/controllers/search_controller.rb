class SearchController < ApplicationController
  skip_before_filter :authenticate_user!
  rescue_from ThinkingSphinx::SphinxError, with: :search_error
  def index
    @search = ThinkingSphinx.search params[:search], :page => params[:page], :per_page => 30
  end
  
  private
  
  def search_error
    flash[:error] = t(:search_is_temporary_unavaliable, scope: :notices)
    redirect_to :back
  end
end