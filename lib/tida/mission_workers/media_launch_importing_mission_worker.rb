# :encoding => utf-8
module Tida
  module MissionWorkers
    class MediaLaunchImportingMissionWorker < ::BackOffice::MissionWorker::Base
      @queue = :retrieve_data
      def do_perform(mission)
        launches = MediaLaunch.where(mission_id: mission.id)
        Rails.logger.debug "Launches count: #{launches.count}"

        launches.each do |launch|
          begin
            body = ::Tida::Network::WebContentRetriever.retrieve launch.url
            doc = ::Tida::Readability::Parser.parse body
            # doc = ::Tida::Readability::Parser.parse launch.url
            launch.calculate_media_value!
            launch.title = doc.title
            launch.word_amount = doc.content.length
            launch.mission_id = nil
            launch.save!
          rescue => e
            Rails.logger.error e
          end
        end
      end
    end
  end
end
