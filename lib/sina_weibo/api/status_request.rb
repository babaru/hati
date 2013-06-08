module SinaWeibo
  module Api
    class StatusRequest
      attr_reader :rest_client

      def initialize(token)
        @rest_client = ::SinaWeibo::Api::Client.new token
      end

      def status_update(content)
        post_request(Settings.weibo.api.status.update, :status => content)
      end

      def status_upload(content, image_path)
        post_request(Settings.weibo.api.status.upload, :status => content, :pic => File.new(image_path, 'rb'))
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
