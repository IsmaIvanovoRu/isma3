class Api::AttachmentsController < ApplicationController
  skip_before_filter :authenticate_user!
  def show
    method = 'attachments/'
    http_params = http_params()
    http = Net::HTTP.new(http_params[:uri_host], http_params[:uri_port], http_params[:proxy_ip], http_params[:proxy_port])
    http.use_ssl = true if Rails.env == 'production'
    response = http.get(http_params[:uri_path] + method + params[:id])
    send_data response.body, filename: params[:filename], disposition: 'attachment'
  end
  
  def create
    method = 'attachments/'
    http_params = http_params()
    url = ['https:/', [http_params[:uri_host], http_params[:uri_port]].join(':'), http_params[:uri_path], method].join('/')
    RestClient.post url, attachment: params
    redirect_to :back
  end
end
