module SinaWeibo
  module Retrievers
    class UserDataRetriever
      def self.retrieve_by_id(user_sw_id)
        Rails.logger.debug "* Retrieving user data by id: #{user_sw_id}"
        user_entity = ::SinaWeibo::Retrievers::UserDataRetriever.retrieve_entity user_sw_id
        ::SinaWeiboUser.create_or_update_from_entity! user_entity
      end

      def self.retrieve_entity(user_sw_id)
        api = ::SinaWeibo::Api::DataRetriever.new
        user_data = api.user_show(user_sw_id)
        if user_data.nil?
          user_data = api.user_domain_show(user_sw_id)
        end
        return nil if user_data.nil?
        ::SinaWeibo::Entity::User.new user_data
      end

      def self.retrieve_by_url(user_sw_url)
        Rails.logger.debug "* Retrieving user data from url: #{user_sw_url}"
        identity = ::SinaWeibo::Retrievers::UserDataRetriever.scratch_user_id_or_domain_from_url(user_sw_url)
        return nil if identity.nil?

        user_entity = ::SinaWeibo::Retrievers::UserDataRetriever.retrieve_entity identity

        return nil if user_entity.nil?
        ::SinaWeiboUser.create_or_update_from_entity! user_entity
      end

      def self.retrieve_by_screen_name(screen_name)
        Rails.logger.debug "* Retrieving user data by screen name: #{screen_name}"

        api = ::SinaWeibo::Api::DataRetriever.new
        user_data = api.user_show(screen_name, false)
        return nil if user_data.nil?
        user_entity = SinaWeibo::Entity::User.new user_data
        ::SinaWeiboUser.create_or_update_from_entity! user_entity
      end

      def self.scratch_user_id_or_domain_from_url(url)
        user_url = url.gsub(/\?.*$/, "")
        user_url = user_url.gsub(/\/$/, '')
        user_url.scan(/.+\/(\d+)$/) do |matches|
          Rails.logger.debug "matches: #{matches}"
          if matches.count > 0
            return matches.first
          end
        end

        user_url.scan(/.+\/(.+)$/) do |matches|
          Rails.logger.debug "matches: #{matches}"
          if matches.count > 0
            return matches.first
          end
        end
        Rails.logger.error "! Failed to get user id from url: #{url}"
        return nil
      end
    end
  end
end
