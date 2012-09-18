class RedsController < ApplicationController
  def index
    Rails.logger.info "Request header: \r\n"
    Rails.logger.info request.env
    render :nothing => true
  end
end
