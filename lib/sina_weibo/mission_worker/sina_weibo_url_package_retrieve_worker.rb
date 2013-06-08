module SinaWeibo
  module MissionWorker
    class SinaWeiboUrlPackageRetrieveWorker < ::BackOffice::MissionWorker::RetrieveWorker
      @queue = :retrieve_data
      def do_perform(mission)
        ::SinaWeibo::Api::AccessTokenProvider.reset
        sina_weibo_url_package  = mission.sina_weibo_url_package
        include_retweets         = mission.include_retweets
        include_comments        = mission.include_comments

        Rails.logger.debug "* Retrieving status data of package #{sina_weibo_url_package.name}(#{sina_weibo_url_package.id})"
        sina_weibo_url_package.sina_weibo_url_package_items.each do |item|
          status = ::SinaWeibo::Retrievers::StatusDataRetriever.retrieve_by_url item.url
          if status
            item.sina_weibo_status_id = status.id
            item.save!
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
      end
    end
  end
end
