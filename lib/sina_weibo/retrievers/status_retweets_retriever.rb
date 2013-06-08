module SinaWeibo
  module Retrievers
    class StatusRetweetsRetriever
      COMMENT_PAGE_SIZE = 50

      def self.retrieve(options = {})
        status_sw_id = options[:status_sw_id]
        page = options[:page]
        page ||= 1
        status = SinaWeiboStatus.find_by_sw_id status_sw_id

        api = ::SinaWeibo::Api::DataRetriever.new

        response_data = api.status_repost_timeline(status_sw_id, page)
        return if response_data.nil?
        retweets_data = response_data['reposts']
        retweets_data.each do |retweet_data|
          retweet_entity = SinaWeibo::Entity::Status.new retweet_data
          retweet = ::SinaWeiboStatus.create_or_update_from_entity! retweet_entity
          retweet.original_status_id = status.id
          retweet.original_status_sw_id = status.sw_id
          retweet.save!
          if block_given?
            yield retweet
          end
        end
      end
    end
  end
end
