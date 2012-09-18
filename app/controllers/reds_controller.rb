class RedsController < ApplicationController
  def index
    Rails.logger.debug "Request header: \r\n"
    Rails.logger.debug request.env

    # uri = URI.parse("http://hati.dev/reds/second_index")
    # http = Net::HTTP.new(uri.host, uri.port)
    # headers = {
    #   'REFERER' => "weibo.com",
    #   'Status' => '302'
    # }
    # http.get(uri.path, headers)
    # render :nothing => true

    headers["HTTP_REFERER"] = "http://old.url"
    redirect_to "http://hati.dev/reds/second_index"
  end

  def second_index
    Rails.logger.debug "Request header: \r\n"
    Rails.logger.debug request.env
    render :nothing => true
  end
end
