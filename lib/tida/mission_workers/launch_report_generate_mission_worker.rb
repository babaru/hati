# :encoding => utf-8
module Tida
  module MissionWorkers
    class LaunchReportGenerateMissionWorker < ::BackOffice::MissionWorker::Base
      @queue = :report
      def do_perform(mission)
        brand = Brand.find mission.relevant_id
        Rails.logger.debug "Generate launch report for brand: #{brand.name}"

        ::Tida::ExcelGenerators::LaunchReportGenerator.generate(brand.id)
      end
    end
  end
end
