module SinaWeibo
  module Api
    class ShortUrlRequest
      attr_reader :rest_client

      def initialize(token)
        @rest_client = ::SinaWeibo::Api::Client.new token
      end

      def shorten(url)
        get_request('https://api.weibo.com/2/short_url/shorten.json', params: {url_long: URI.escape(url)})
      end

      def share_statuses(url)
        get_request('https://api.weibo.com/2/short_url/share/statuses.json', params: {url_short: URI.escape(url)})
      end

      private

      def post_request(url, data)
        rest_client.post_request(url, data)
      end

      def get_request(url, data)
        rest_client.get_request(url, data)
      end
    end
  end
end
