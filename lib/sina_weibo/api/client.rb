module SinaWeibo
  module Api
    class Client
      attr_reader :access_token

      def initialize(token)
        @access_token = token
      end

      def post_request(url, data)
        rest_request(url, data, true)
      end

      def get_request(url, data)
        rest_request(url, data, false)
      end

      private

      def rest_request(url, data, method_post)
        if method_post
          rd  = data.clone
          rd[:access_token] = @access_token
          r = JSON.parse RestClient.post(url, rd)
          Rails.logger.debug "- Request response: #{r}"
          return r
        else
          rd  = data.clone
          params = {:access_token => @access_token}
          rd[:params] = data[:params].merge(params)
          Rails.logger.debug "Request params hash is #{rd}"

          r = JSON.parse RestClient.get(url, rd)
          Rails.logger.debug "- Request response: #{r}"
          return r
        end
      rescue ::RestClient::Exception => e
        Rails.logger.error "= Request Failed #{e.to_s}"
        r = JSON.parse e.http_body
        Rails.logger.error "= Sina Weibo API Error Code: #{r["error_code"]} Error: #{r["error"]}"
        api_error_code = r["error_code"].to_i

        if invalid_access_token? api_error_code
          raise ::SinaWeibo::Api::InvalidAccessTokenException.new
        end

        if reached_account_access_limit? api_error_code
          raise ::SinaWeibo::Api::AccountAccessLimitException.new
        end

        if reached_ip_access_limit? api_error_code
          raise ::SinaWeibo::Api::IPAccessLimitException.new
        end

        return nil
      rescue => e
        Rails.logger.error "= Unknown error: #{e.to_s}"
        return nil
      end

      def parse_response(&block)
        JSON.parse(block.call)
      end

      def invalid_access_token?(error_code)
        return error_code == 21332 || error_code == 21327
      end

      def reached_account_access_limit?(error_code)
        return error_code == 10023 || error_code == 10024
      end

      def reached_ip_access_limit?(error_code)
        return error_code == 10022
      end
    end
  end
end
