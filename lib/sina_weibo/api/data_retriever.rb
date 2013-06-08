module SinaWeibo
  module Api
    class DataRetriever
      attr_reader :rest_client

      def initialize
        @rest_client = ::SinaWeibo::Api::Client.new ::SinaWeibo::Api::AccessTokenProvider.token
      end

      def status_user_timeline(uid, page = 1, count = 100)
        get_request(Settings.weibo.api.status.user_timeline, :params => {:uid => uid, :page => page, :count => count})
      end

      def status_repost_timeline(post_id, page = 1)
        get_request(Settings.weibo.api.status.repost_timeline, :params => {:id => post_id, :page => page, :count => 50})
      end

      def comments_show(post_id, page = 1)
        get_request(Settings.weibo.api.comments.show, :params => {:id => post_id, :page => page, :count => 50})
      end

      def status_show(wb_post_id)
        get_request(Settings.weibo.api.status.show, :params => {:id => wb_post_id})
      end

      def user_show(uid, is_number_id = true)
        if is_number_id
          get_request(Settings.weibo.api.user.show, {:params => {:uid => uid}})
        else
          get_request(Settings.weibo.api.user.show, {:params => {:screen_name => uid}})
        end
      end

      def user_domain_show(domain)
        get_request(Settings.weibo.api.user.domain_show, :params => {:domain => domain})
      end

      def friendships_followers(uid, cursor)
        get_request(Settings.weibo.api.friendships.followers, :params => {:uid => uid, :cursor => cursor})
      end

      def friendships_followers_ids(uid, cursor)
        get_request(Settings.weibo.api.friendships.followers_ids, :params => {:uid => uid, :cursor => cursor})
      end

      def tags(uid)
        get_request(Settings.weibo.api.tags, :params => {:uid => uid})
      end

      def queryid(mid)
        data = get_request(Settings.weibo.api.status.queryid, {:params => {:mid => mid, :type => 1, :isBase62 => 1}})
      end

      def querymid(id, batch = false)
        data = get_request(Settings.weibo.api.status.querymid, {:params => {:id => id, :type => 1, :is_batch => batch ? 1 : 0}})
      end

      def querymids(ids)
        ids_str = ids.join(',')
        querymid(ids_str, true)
      end

      private

      def get_request(url, data)
        rest_request(url, data)
      end

      def rest_request(url, data)
        result, code = do_request url, data

        while code == -1
          change_access_token
          result, code = do_request url, data
        end

        return result
      end

      def do_request(url, data)
        r = rest_client.get_request url, data
        return r, 0
      rescue ::SinaWeibo::Api::AccessTokenException => e
        return nil, -1
      rescue
        return nil, -2
      end

      def change_access_token
        Rails.logger.info "* Changing access token}"
        Rails.logger.info "- Old access token is #{@rest_client.access_token}"
        ::SinaWeibo::Api::AccessTokenProvider.change
        @rest_client = ::SinaWeibo::Api::RestClient.new ::SinaWeibo::Api::AccessTokenProvider.token
        Rails.logger.info "- New access token is #{@rest_client.access_token}"
        if @rest_client.access_token.nil?
          raise ::SinaWeibo::Api::NoAccessTokenAvaiableException.new
        end
      end
    end
  end
end
