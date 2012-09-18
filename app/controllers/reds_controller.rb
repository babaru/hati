class RedsController < ApplicationController
  def index
    Rails.logger.info "Request /index header: \r\n"
    Rails.logger.info request.env
    redirect_to "http://hati.tfocusclub.com/reds/sec"
  end

  def sec
    Rails.logger.info "Request /sec header: \r\n"
    Rails.logger.info request.env
    render :nothing => true
  end
end
