module Tida
  module Readability
    class ArticleParseMissionWorker < ::BackOffice::MissionWorker::Base
      @queue = :retrieve_data

      def do_perform(mission)
        launches = Launch.where("brand_id=#{mission.brand_id} and type='#{mission.launch_type}' and title is null")
        launches.each do |launch|
          launch.refresh_data
        end
      end
    end
  end
end
