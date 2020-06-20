class Api::DictionariesController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    method = 'dictionaries'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    response = http.get(http_params[:uri_path] + method)
    render json: response.body
  end
  
  def show
    method = 'dictionaries/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    response = http.get(http_params[:uri_path] + method + params[:id])
    render json: response.body
  end
end
