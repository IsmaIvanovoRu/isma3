class Api::EntrantApplicationsController < ApplicationController
  skip_before_filter :authenticate_user!
  def show
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port]) if Rails.env == 'development'
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port], :use_ssl => uri.scheme == 'https') if Rails.env == 'production'
    response = http.get(http_params[:uri_path] + method + params[:id])
    render json: response.body
  end
  
  def create
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port]) if Rails.env == 'development'
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port], :use_ssl => uri.scheme == 'https') if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.post(http_params[:uri_path] + method, params.to_json, headers)
    redirect_to entrant_url(JSON.parse(response.body)['hash'])
  end
end
