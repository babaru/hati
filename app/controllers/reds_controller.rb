class RedsController < ApplicationController
  def index
    Rails.logger.debug "Request header: \r\n"
    Rails.logger.debug request.env
    render :nothing => true
  end
end
