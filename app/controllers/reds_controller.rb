class RedsController < ApplicationController
  layout 'reds'
  
  def index
    Rails.logger.info "Request /index header: \r\n"
    Rails.logger.info request.env
    redirect_to :action => :sec
  end

  def sec
    Rails.logger.info "Request /sec header: \r\n"
    Rails.logger.info request.env
  end
end
