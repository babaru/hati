class RedsController < ApplicationController
  layout 'reds'

  def index
    Rails.logger.info "Request /index header: \r\n"
    Rails.logger.info request.env

    Click.create header:request.env.to_s, referal:request.env["HTTP_REFERER"], remote_ip:request.env["REMOTE_ADDR"]

    redirect_to :action => :sec
  end

  def sec
    Rails.logger.info "Request /sec header: \r\n"
    Rails.logger.info request.env
  end
end
