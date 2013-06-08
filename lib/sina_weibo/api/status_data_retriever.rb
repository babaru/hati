require "observer"

module SinaWeibo
  module Api
    class StatusDataRetriever
      attr_reader :data_retriever

      STATUS_PAGE_SIZE = 100
      RETWEETED_PAGE_SIZE = 50

      def initialize
        @data_retriever = SinaWeibo::Api::DataRetriever.new
      end

      def retrieve_from_url(status_url)
        Rails.logger.info "* Retrieving data from status url: #{status_url}"

        status_mid = scratch_mid_from_url status_url
        Rails.logger.debug "- mid: #{status_mid}"

        status_id_data = data_retriever.queryid(status_mid)
        if status_id_data
          status_id = status_id_data["id"]
          Rails.logger.debug "- Status id: #{status_id}"
          status_data = data_retriever.status_show status_id
          return nil if status_data.nil?
          return SinaWeibo::Entity::Status.new status_data
        end
        return nil
      end

      def retrieve_status_retweeted_statuses(options)
        status_id = options[:status_id]
        retweeted_count = options[:retweeted_count]
        Rails.logger.info "* Retrieving all retweeted statuses of status #{status_id}"

        total_pages = (retweeted_count / RETWEETED_PAGE_SIZE.to_f).ceil
        Rails.logger.info "- There are #{total_pages} pages (#{RETWEETED_PAGE_SIZE} per page) retweeted statuses"

        1.upto(total_pages) do |page|
          response_data = data_retriever.status_repost_timeline(status_id, page)
          Rails.logger.error "! There is no response data on page #{page}" and break if response_data.nil? || response_data == []
          retweeted_result_data = response_data['reposts']
          Rails.logger.error "! There is no repost data on page #{page}" and break if retweeted_result_data.nil?
          Rails.logger.info "- There are #{retweeted_result_data.count} records on page #{page}"
          retweeted_result_data.each do |retweeted_data|
            retweeted = SinaWeibo::Entity::Status.new retweeted_data
            if block_given?
              yield retweeted
            end
          end
        end

        Rails.logger.info "- Retrieving retweeted statuses of status #{status_id} done"
      end

      # def retrieve_user_statuss(user, from, to)
      #   from ||= 7.days.ago.strftime('%Y-%m-%d')
      #   to ||= Time.now.strftime('%Y-%m-%d')

      #   Rails.logger.info "* 正在处理 @#{user.wb_screen_name} 的所有微博"

      #   total_pages = (user.wb_statuses_count / STATUS_PAGE_COUNT.to_f).ceil
      #   Rails.logger.info "- @#{user.wb_screen_name} 共有#{user.wb_statuses_count}条微博，共#{total_pages}页(每页#{STATUS_PAGE_COUNT}条记录)"

      #   1.upto(total_pages) do |page|
      #     response_data = self.data_retriever.status_user_timeline(user.wb_id, page)
      #     Rails.logger.error("! There is no response data on page #{page} of @#{user.wb_screen_name}") and return if response_data.nil?
      #     statuss_data = response_data['statuses']
      #     Rails.logger.info "- 第#{page}页共有#{statuss_data.count}条记录"

      #     statuss_data.each do |status_data|
      #       status = WeiboPost.parse(status_data)
      #       break if status.wb_created_at.strftime('%Y-%m-%d') < from
      #       next if status.wb_created_at.strftime('%Y-%m-%d') > to
      #       if block_given?
      #         yield status
      #       end
      #     end
      #   end

      #   Rails.logger.info "- @#{user.wb_screen_name} 处理完毕"
      # end

      def retrieve_urls(status_ids)
        data_retriever.querymids status_ids
      end

      def scratch_mid_from_url(url)
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
