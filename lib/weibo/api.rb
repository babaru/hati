module Weibo
  class API
    attr_reader :access_token
    
    def initialize
      @access_token = Mole.token
    end
    
    def status_update(content)
      post_request(Settings.weibo.api.status.update, :params => {:status => content})
    end
    
    def status_upload(content, image_path)
      post_request(Settings.weibo.api.status.upload, :params => {:status => content, :pic => File.new(image_path, 'rb')})
    end

    def queryid(mid)
      data = get_request(Settings.weibo.api.status.queryid, {:params => {:mid => mid, :type => 1, :isBase62 => 1}})
      data["id"]
    end

    def querymid(id)
      data = get_request(Settings.weibo.api.status.querymid, {:params => {:id => id, :type => 1, :is_batch => 0}})
      data["mid"]
    end
    
    private
    
    def post_request(url, data)
      rest_request(url, data, true)
    end
    
    def get_request(url, data)
      rest_request(url, data, false)
    end
    
    def rest_request(url, data, method_post)
      params = {:access_token => @access_token}
      data[:params] = data[:params].merge(params)
      Rails.logger.debug "Request params hash is #{data}"
      begin
        parse_response do
          if method_post
            r = JSON.parse RestClient.post(url, data[:params])
            Rails.logger.debug "- Request response: #{r}"
            return r
          else
            r = JSON.parse RestClient.get(url, data)
            Rails.logger.debug "- Request response: #{r}"
            return r
          end
        end
      rescue RestClient::Exception => e
        Rails.logger.error "! Request Failed #{e.to_s}"
        r = JSON.parse e.http_body
        Rails.logger.error "! Sina Weibo API Error Code: #{r["error_code"]} Error: #{r["error"]}"
        api_error_code = r["error_code"].to_i

        if invalid_access_token? api_error_code
          return change_access_token do 
            rest_request(url, data, method_post)
          end
        end

        if reached_account_access_limit? api_error_code
          return change_access_token do 
            rest_request(url, data, method_post)
          end
        end

        if reached_ip_access_limit? api_error_code
          raise IPAccessLimitException.new
        end

        return r
      end
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

    def change_access_token(&block)
      Rails.logger.info "* Changing access token}"
      Rails.logger.info "- Old access token is #{@access_token}"
      Mole.expire @access_token
      @access_token = Mole.token
      Rails.logger.info "- New access token is #{@access_token}"
      if @access_token.nil?
        raise NoAccessTokenAvaiableException.new
      end
      return block.call
    end
  end
end