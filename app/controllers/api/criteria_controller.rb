class Api::CriteriaController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token

  def index
    acceptor_type = params[:acceptor_type]
    @criteria = Criterium.order(:chapter, :point).where(actual: true, acceptor_type: acceptor_type)
  end
end