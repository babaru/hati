class RedsController < ApplicationController
  layout 'reds'

  def index
    logger.debug request.env

    reds = Reds.find_by_code params[:code]
    render and return if reds.nil?

    Click.create header:request.env.to_s, referal:request.env["HTTP_REFERER"], remote_ip:request.env["REMOTE_ADDR"], reds_id:reds.id, real_ip:request.env["HTTP_X_REAL_IP"], forwarded_for:request.env["HTTP_X_FORWARDED_FOR"]
    @url = reds.url
  end

  def jump
    reds = Reds.find_by_code params[:code]
    render and return if reds.nil?
    @url = reds.url
  end
end
