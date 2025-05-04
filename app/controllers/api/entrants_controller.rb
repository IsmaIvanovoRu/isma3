class Api::EntrantsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token
  def show
    method = 'entrants/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    response = http.get(http_params[:uri_path] + method + params[:id])
    render json: response.body
  end

  def create
    method = 'entrants/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.post(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end

  def update
    method = 'entrants/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method + params[:id], params.to_json, headers)
    render json: response.body
  end

  def check_email
    method = "entrants/check_email"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.post(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def resend_email
    method = "entrants/resend_email"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.post(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_entrant_application
    method = "entrants/#{params[:id]}/generate_entrant_application"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_consent_applications
    method = "entrants/#{params[:id]}/generate_consent_applications"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_withdraw_applications
    method = "entrants/#{params[:id]}/generate_withdraw_applications"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
  
  def generate_contracts
    method = "entrants/#{params[:id]}/generate_contracts"
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    headers = {"Content-Type" => "application/json", "Accept" => "application/json"}
    response = http.put(http_params[:uri_path] + method, params.to_json, headers)
    render json: response.body
  end
end
