class Api::CampaignsController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    method = 'campaigns'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port], http_params[:use_ssl])
    response = http.get(http_params[:uri_path] + method)
    render json: response.body
  end
end
