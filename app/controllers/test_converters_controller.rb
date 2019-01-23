class TestConvertersController < ApplicationController
  before_action :require_moderator

  def mytest2moodle
    output_file = TestConverter.mytest2moodle(params[:file])
    send_data output_file.values.first, filename: output_file.keys.first
  end
end
