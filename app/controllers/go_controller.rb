class GoController < ApplicationController
  layout 'go'

  def index
    go = Go.find_by_code params[:code]
    render and return if go.nil?
    AccessLog.create!({
      header: request.env.to_s,
      referal: request.env["HTTP_REFERER"],
      remote_ip: request.env["REMOTE_ADDR"],
      go_code: params[:code],
      go_id: go.id,
      real_ip: request.env["HTTP_X_REAL_IP"],
      forwarded_for: request.env["HTTP_X_FORWARDED_FOR"]
    })

    @go_url = go.url
  end
end
