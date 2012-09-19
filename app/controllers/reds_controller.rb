class RedsController < ApplicationController
  layout 'reds'

  def index
    logger.debug request.env

    reds = Reds.find_by_code params[:code]
    render and return if reds.nil?

    Click.create header:request.env.to_s, referal:request.env["HTTP_REFERER"], remote_ip:request.env["REMOTE_ADDR"], reds_id:reds.id
    @url = reds.url

    # redirect_to reds.url
  end
end
