module SinaWeibo
  module MissionWorker
    class UserStatusesRetrieveWorker < ::BackOffice::MissionWorker::RetrieveWorker
      @queue = :retrieve_data
      def do_perform(mission)
        ::SinaWeibo::Api::AccessTokenProvider.reset
        user              = ::SinaWeiboUser.find_by_sw_id mission.user_sw_id
        from              = mission.from
        to                = mission.to
        latest_page        = mission.latest_page
        include_retweets = mission.include_retweets
        include_comments = mission.include_comments
        status_page_size = ::SinaWeibo::Retrievers::UserStatusesRetriever::STATUS_PAGE_SIZE
        total_pages = (user.statuses_count / status_page_size.to_f).ceil

        status_ids_waiting_for_retrieving_mids = []

        too_old = false
        (latest_page..total_pages).each do |page|
          break if too_old
          too_old = ::SinaWeibo::Retrievers::UserStatusesRetriever.retrieve user_sw_id: user.sw_id, page: page, from: from, to: to do |status|
            Rails.logger.info "- Retrieved status #{status.sw_id} of @#{user.screen_name}(#{user.sw_id})"

            status_ids_waiting_for_retrieving_mids << status.sw_id if status.url.nil? || status.url.empty?
            if status_ids_waiting_for_retrieving_mids.count == 20
              ::SinaWeibo::Retrievers::StatusUrlsRetriever.retrieve status_ids: status_ids_waiting_for_retrieving_mids
              Rails.logger.info "- Retrieved urls of statuses #{status_ids_waiting_for_retrieving_mids}"
              status_ids_waiting_for_retrieving_mids = []
            end

            if include_retweets && status.reposts_count > 0
              retweet_mission = ::SinaWeiboStatusRetweetsRetrieveMission.new
              retweet_mission.parent_id = mission.id
              retweet_mission.relevant_id = status.id
              retweet_mission.sina_weibo_status_id = status.sw_id
              retweet_mission.retweets_count = status.reposts_count
              retweet_mission.latest_page = 1
              retweet_mission.error = nil
              retweet_mission.save!

              Resque.enqueue SinaWeibo::MissionWorker::StatusRetweetsRetrieveWorker, retweet_mission.id
              retweet_mission.enqueue!
            end

            if include_comments && status.comments_count > 0
              comment_mission = ::SinaWeiboStatusCommentsRetrieveMission.new
              comment_mission.parent_id = mission.id
              comment_mission.relevant_id = status.id
              comment_mission.sina_weibo_status_id = status.sw_id
              comment_mission.comments_count = status.comments_count
              comment_mission.latest_page = 1
              comment_mission.error = nil
              comment_mission.save!

              Resque.enqueue SinaWeibo::MissionWorker::StatusCommentsRetrieveWorker, comment_mission.id
              comment_mission.enqueue!
            end
          end

          notify mission.id, latest_page: page, from: from, to: to
        end

        if status_ids_waiting_for_retrieving_mids.count > 0
          ::SinaWeibo::Retrievers::StatusUrlsRetriever.retrieve status_ids: status_ids_waiting_for_retrieving_mids
          status_ids_waiting_for_retrieving_mids = []
        end
      end
    end
  end
end
