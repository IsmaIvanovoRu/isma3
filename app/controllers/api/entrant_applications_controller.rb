class Api::EntrantApplicationsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token
  def show
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    response = http.get(http_params[:uri_path] + method + params[:id])
    render json: response.body
  end

  def create
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.post(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end

  def update
    method = 'entrant_applications/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method + params[:id], params.to_json, headers)
    render json: response.body
  end

  def check_email
    method = "entrant_applications/check_email"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.post(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def check_pin
    method = "entrant_applications/#{params[:id]}/check_pin"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end

  def remove_pin
    method = "entrant_applications/#{params[:id]}/remove_pin"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_entrant_application
    method = "entrant_applications/#{params[:id]}/generate_entrant_application"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_consent_applications
    method = "entrant_applications/#{params[:id]}/generate_consent_applications"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_withdraw_applications
    method = "entrant_applications/#{params[:id]}/generate_withdraw_applications"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def send_welcome_email
    method = "entrant_applications/#{params[:id]}/send_welcome_email"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
end
