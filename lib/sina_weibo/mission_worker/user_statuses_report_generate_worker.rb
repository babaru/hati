module SinaWeibo
  module MissionWorker
    class UserStatusesReportGenerateWorker < ::BackOffice::MissionWorker::Base
      @queue = :report
      def do_perform(mission)
        sina_weibo_user_id = mission.sina_weibo_user_id
        from = mission.from
        to = mission.to

        Rails.logger.debug "* Generating report of user #{sina_weibo_user_id}"
        ::SinaWeibo::ReportGenerators::UserStatusesReportGenerator.generate sina_weibo_user_id: sina_weibo_user_id, from: from, to: to
        notify mission.id, sina_weibo_user_id: sina_weibo_user_id, from: from, to: to
      end
    end
  end
end
