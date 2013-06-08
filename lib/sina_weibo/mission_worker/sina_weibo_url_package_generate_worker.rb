module SinaWeibo
  module MissionWorker
    class SinaWeiboUrlPackageGenerateWorker < ::BackOffice::MissionWorker::Base
      @queue = :report
      def do_perform(mission)
        report_type = mission.report_type

        Rails.logger.debug "* Generating url package report type: #{report_type} of #{mission.sina_weibo_url_package.name}(#{mission.relevant_id})"
        if report_type == 1
          ::SinaWeibo::ReportGenerators::SinaWeiboUrlPackageGenerator.generate sina_weibo_url_package_id: mission.relevant_id
        end

        if report_type == 2
          ::SinaWeibo::ReportGenerators::SinaWeiboUrlPackageCommentReportGenerator.generate sina_weibo_url_package_id: mission.relevant_id
        end
      end
    end
  end
end
