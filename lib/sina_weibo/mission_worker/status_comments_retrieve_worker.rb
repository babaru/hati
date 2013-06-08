module SinaWeibo
  module MissionWorker
    class StatusCommentsRetrieveWorker < ::BackOffice::MissionWorker::RetrieveWorker
      @queue = :retrieve_data
      def do_perform(mission)
        ::SinaWeibo::Api::AccessTokenProvider.reset
        sina_weibo_status_id = mission.sina_weibo_status_id
        comments_count = mission.comments_count
        latest_page = mission.latest_page

        Rails.logger.debug "* Retrieving comments of status #{sina_weibo_status_id}"
        total_pages = (comments_count / ::SinaWeibo::Retrievers::StatusCommentsRetriever::COMMENT_PAGE_SIZE.to_f).ceil
        Rails.logger.debug "- There are #{total_pages} pages (#{::SinaWeibo::Retrievers::StatusCommentsRetriever::COMMENT_PAGE_SIZE} per page) comments of status #{sina_weibo_status_id}"
        latest_page.upto(total_pages) do |page|
          ::SinaWeibo::Retrievers::StatusCommentsRetriever.retrieve status_sw_id: sina_weibo_status_id, page: page do |comment|
          end
          notify mission.id, sina_weibo_status_id: sina_weibo_status_id, latest_page: page, comments_count: comments_count
        end
      end
    end
  end
end
