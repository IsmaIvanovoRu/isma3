class EntrantsController < ApplicationController
  skip_before_filter :authenticate_user!
  def new
  end
  
  def show
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    response = http.get(http_params[:uri_path] + method + params[:id])
    @entrant_application = JSON.parse(response.body)
  end
end
