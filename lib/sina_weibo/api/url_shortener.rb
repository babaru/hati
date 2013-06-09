module SinaWeibo
  module Api
    class UrlShortener
      attr_reader :url_shorten_request

      STATUS_PAGE_SIZE = 100
      FOLLOWER_PAGE_SIZE = 50

      def initialize(access_token)
        @url_shorten_request = SinaWeibo::Api::ShortUrlRequest.new access_token
      end

      def shorten(url)
        result = url_shorten_request.shorten url
        return result["urls"][0]["url_short"] if result["urls"] && result["urls"].length > 0 && result["urls"][0]["result"]
        nil
      end

      def share_statuses(url)
        result = url_shorten_request.share_statuses url
        result["share_statuses"]
      end
    end
  end
end
