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

  def shorten
    if request.post?
      @go = Go.find_by_code params[:shorten][:code]
      api = SinaWeibo::Api::ShortenUrlRequest.new '2.00bA8_nBoJOHoD35177487ac7atD1E'
      result = api.shorten "http://go.sptida.com/go/#{code}"
      @go.sina_weibo_shorten_url = result['urls'][0]['url_short']
      @go.save
    end
  end
end
