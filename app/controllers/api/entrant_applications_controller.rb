class Api::EntrantApplicationsController < ApplicationController
  skip_before_filter :authenticate_user!
  def show
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    response = http.get(http_params[:uri_path] + method + params[:id])
    render json: response.body
  end
  
  def create
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    headers = {'Content-Type': 'application/json'}
    response = http.post(http_params[:uri_path] + method, '{}', headers)
    render json: response.body
  end
end
