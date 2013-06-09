# :encoding => utf-8
module Tida
  module MissionWorkers
    class WeiboLaunchImportingMissionWorker < ::BackOffice::MissionWorker::Base
      @queue = :retrieve_data
      def do_perform(mission)
        launches = WeiboLaunch.where(mission_id: mission.id)
        Rails.logger.debug "Launches count: #{launches.count}"

        launches.each do |launch|
          status = ::SinaWeibo::Retrievers::StatusDataRetriever.retrieve_by_url launch.url
          if status
            launch.sina_weibo_status_id = status.id
            launch.mission_id = nil
            launch.launched_at = status.sw_created_at
            launch.save!
          end
        end
      end
    end
  end
end
