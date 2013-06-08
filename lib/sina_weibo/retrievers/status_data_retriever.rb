module SinaWeibo
  module Retrievers
    class StatusDataRetriever
      def self.retrieve_by_id(sw_id)
        Rails.logger.debug "* Retrieving status data by id: #{sw_id}"
        status_entity = ::SinaWeibo::Retrievers::StatusDataRetriever.retrieve_entity sw_id
        status_entity.encrypted_mid = ::SinaWeibo::Retrievers::StatusDataRetriever.retrieve_encrypted_mid sw_id
        status_entity.url = "http://weibo.com/#{status_entity.user.id}/#{status_entity.encrypted_mid}"
        ::SinaWeiboStatus.create_or_update_from_entity! status_entity
      end

      def self.retrieve_by_url(url)
        Rails.logger.info "* Retrieving status data from url: #{url}"

        mid = ::SinaWeibo::Retrievers::StatusDataRetriever.scratch_status_encrypted_mid_from_url url
        Rails.logger.debug "- mid: #{mid}"
        api = ::SinaWeibo::Api::DataRetriever.new
        sw_id_data = api.queryid(mid)
        if sw_id_data
          sw_id = sw_id_data["id"]
          Rails.logger.debug "- Status id: #{sw_id}"
          entity = ::SinaWeibo::Retrievers::StatusDataRetriever.retrieve_entity sw_id
          if entity
            entity.url = url
            entity.encrypted_mid = mid
            return ::SinaWeiboStatus.create_or_update_from_entity! entity
          else
            return nil
          end
        else
          Rails.logger.error "! Do not find any status by sw_id: #{sw_id}" and return nil
        end
      end

      def self.retrieve_entity(sw_id)
        api = ::SinaWeibo::Api::DataRetriever.new
        status_data = api.status_show(sw_id)
        return nil if status_data.nil?
        ::SinaWeibo::Entity::Status.new status_data
      end

      def self.retrieve_encrypted_mid(sw_id)
        api = ::SinaWeibo::Api::DataRetriever.new
        response = api.querymid(sw_id)
        response["mid"]
      end

      def self.scratch_status_encrypted_mid_from_url(url)
        url.scan(/.+\/(.+)$/) do |matches|
          Rails.logger.debug "matches: #{matches}"
          if matches.count > 0
            return matches.first.gsub(/\s+/, "").gsub(/#.*$/, "")
          end
        end
        nil
      end
    end
  end
end
