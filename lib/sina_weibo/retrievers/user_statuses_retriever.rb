module SinaWeibo
  module Retrievers
    class UserStatusesRetriever
      STATUS_PAGE_SIZE = 100

      def self.retrieve(options = {})
        user_sw_id = options[:user_sw_id]
        page = options[:page]
        after = options[:from]
        before = options[:to]

        api = ::SinaWeibo::Api::DataRetriever.new

        response_data = api.status_user_timeline(user_sw_id, page)
        Rails.logger.error("! There is no response data on page #{page} of user #{user_sw_id}") and return if response_data.nil?

        statuses_data = response_data['statuses']
        Rails.logger.debug "- There are #{statuses_data.count} record on page #{page} of user #{user_sw_id}"

        too_old = false
        statuses_data.each do |status_data|
          status_entity = SinaWeibo::Entity::Status.new status_data
          if status_entity.created_at.strftime("%Y-%m-%d") < after
            too_old = true
            break
          end
          next if status_entity.created_at.strftime("%Y-%m-%d") > before
          if block_given?
            yield ::SinaWeiboStatus.create_or_update_from_entity! status_entity
          end
        end

        return too_old
      end
    end
  end
end
