module SinaWeibo
  module MissionWorker
    class StatusRetweetsRetrieveWorker < ::BackOffice::MissionWorker::RetrieveWorker
      @queue = :retrieve_data
      def do_perform(mission)
        ::SinaWeibo::Api::AccessTokenProvider.reset
        context = mission.context
        sina_weibo_status_id = mission.sina_weibo_status_id
        retweets_count = mission.retweets_count
        latest_page = mission.latest_page

        Rails.logger.debug "* Retrieving retweets of status #{sina_weibo_status_id}"
        total_pages = (retweets_count / ::SinaWeibo::Retrievers::StatusRetweetsRetriever::COMMENT_PAGE_SIZE.to_f).ceil
        Rails.logger.debug "- There are #{total_pages} pages (#{::SinaWeibo::Retrievers::StatusRetweetsRetriever::COMMENT_PAGE_SIZE} per page) retweets of status #{sina_weibo_status_id}"
        latest_page.upto(total_pages) do |page|
          ::SinaWeibo::Retrievers::StatusRetweetsRetriever.retrieve status_sw_id: sina_weibo_status_id, page: page do |retweet|
            Rails.logger.debug "- Retrieved retweet #{retweet.sw_id} of status #{sina_weibo_status_id}"
          end

          notify mission.id, sina_weibo_status_id: sina_weibo_status_id, latest_page: page, retweets_count: retweets_count
        end
      end
    end
  end
end
