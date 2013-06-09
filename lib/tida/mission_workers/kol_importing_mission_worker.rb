# :encoding => utf-8
module Tida
  module MissionWorkers
    class KolImportingMissionWorker < ::BackOffice::MissionWorker::Base
      @queue = :retrieve_data
      def do_perform(mission)
        kols = Kol.where(mission_id: mission.id)
        Rails.logger.debug "Kols count: #{kols.count}"

        kols.each do |kol|
          user = ::SinaWeibo::Retrievers::UserDataRetriever.retrieve_by_url kol.social_network_account_url
          if user
            kol.relevant_account_data_id = user.id
            kol.gender = user.gender
            kol.location = user.location
            kol.followers_count = user.followers_count
            kol.avatar_url = user.profile_image_url
            kol.name = user.screen_name
            kol.mission_id = nil
            kol.save!
          end
        end
      end
    end
  end
end
