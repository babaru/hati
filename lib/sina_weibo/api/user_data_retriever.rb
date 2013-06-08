module SinaWeibo
  module Api
    class UserDataRetriever
      attr_reader :data_retriever

      STATUS_PAGE_SIZE = 100
      FOLLOWER_PAGE_SIZE = 50

      def initialize
        @data_retriever = SinaWeibo::Api::DataRetriever.new
      end

      def retrieve_by_id(id)
        Rails.logger.info "* Retrieving user data of id: #{id}"
        SinaWeibo::Entity::User.new data_retriever.user_show(id)
      end

      def retrieve_from_url(url)
        Rails.logger.info "* Retrieving user data from url: #{url}"
        user_id = WeiboUser.scratch_user_id_or_domain_from_url(url)
        return nil if user_id.nil?

        data = nil
        data = data_retriever.user_show(user_id)
        if data.nil?
          data = data_retriever.user_domain_show(user_id)
        end

        if data.nil?
          return nil
        else
          return SinaWeibo::Entity::User.new data
        end
      end

      def retrieve_by_screen_name(screen_name)
        Rails.logger.info "* Retrieving user data of screen name: #{screen_name}"

        data = nil
        data = data_retriever.user_show(screen_name, false)
        return nil if data.nil?
        return SinaWeibo::Entity::User.new data
      end

      def retrieve_statuses(options = {})
        user_id = options[:user_id]
        user_name = options[:user_name]
        status_count = options[:status_count]
        after = options[:from]
        before = options[:to]
        # mission_id = options[:mission_id]

        status_count ||= 0
        after ||= 7.days.ago.strftime('%Y-%m-%d')
        before ||= Time.now.strftime('%Y-%m-%d')

        Rails.logger.info "* Retrieving all statuses from #{after} to #{before} of user #{user_name}[#{user_id}]"

        total_pages = (status_count / STATUS_PAGE_SIZE.to_f).ceil
        Rails.logger.info "- There are #{total_pages} pages (#{STATUS_PAGE_SIZE} per page) statuses of user #{user_name}[#{user_id}]"

        1.upto(total_pages) do |page|
          response_data = data_retriever.status_user_timeline(user_id, page)
          Rails.logger.error("! There is no response data on page #{page} of user #{user_name}[#{user_id}]") and return if response_data.nil?
          statuses_data = response_data['statuses']
          Rails.logger.info "- There are #{statuses_data.count} record on page #{page} of user #{user_name}[#{user_id}]"

          statuses_data.each do |status_data|
            Rails.logger.debug status_data
            status = SinaWeibo::Entity::Status.new status_data
            break if status.created_at.strftime("%Y-%m-%d") < after
            next if status.created_at.strftime("%Y-%m-%d") > before
            if block_given?
              yield status
            end
          end

          # notify_observer mission_id, doing: :retrieving_user_statues, page: page, user_id: user_id
        end

        Rails.logger.info "- All statuses of user #{user_name} done"
      end

      def retrieve_followers(options = {})
        user_id = options[:user_id]
        user_name = options[:user_name]
        followers_count = options[:followers_count]
        # mission_id = options[:mission_id]

        Rails.logger.info "* Retrieving all followers of @#{user_name}(#{user_id})"
        total_pages = (followers_count / FOLLOWER_PAGE_SIZE.to_f).ceil

        (0..total_pages).each do |page|
          data = data_retriever.friendships_followers user_id, page * FOLLOWER_PAGE_SIZE
          users_data = data["users"]
          users_data.each do |user_data|
            user_entity = SinaWeibo::Entity::User.new user_data
            if block_given?
              yield user_entity
            end
          end

          # notify_observer mission_id, doing: :retrieving_user_followers, page: page, user_id: user_id
        end
      end

    end
  end
end
