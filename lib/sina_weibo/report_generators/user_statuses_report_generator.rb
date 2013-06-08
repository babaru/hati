module SinaWeibo
  module ReportGenerators
    class UserStatusesReportGenerator
      def self.generate(options = {})
        sina_weibo_user_id = options[:sina_weibo_user_id]
        from = options[:from]
        from ||= 7.days.ago.strftime('%Y-%m-%d')
        to = options[:to]
        to ||= Time.now.strftime('%Y-%m-%d')

        user = SinaWeiboUser.find sina_weibo_user_id
        statuses = user.statuses.where('date(sw_created_at) >= ? and date(sw_created_at) <= ?', from, to)

        report_file = nil
        Axlsx::Package.new do |ap|
          ap.workbook do |book|
            book.add_worksheet name: 'statuses' do |sheet|
              sheet.add_row ['user', 'user url', 'status url', 'created at', 'status text', 'reposts count', 'comments count']
              Rails.logger.debug "Statuses Count: #{statuses.count}"
              statuses.each do |status|
                sheet.add_row [
                  status.sina_weibo_user.screen_name,
                  status.sina_weibo_user.url,
                  status.url,
                  status.sw_created_at.to_s(:db),
                  status.text,
                  status.reposts_count,
                  status.comments_count
                ]
              end
            end
          end
          report_folder = File.join Rails.root, Settings.file_system.sina_weibo_report_root
          FileUtils.mkdir_p report_folder unless File.exist?(report_folder)
          report_file = File.join report_folder, "#{user.screen_name}_#{Time.now.strftime("%Y-%m-%d")}_at_#{Time.now.strftime("%H%M%S")}.xlsx"
          ap.serialize report_file
          Rails.logger.info "* Created report succeed: #{report_file}"
        end

        box_uploader = ::BackOffice::Box::Uploader.new
        box_uploader.upload report_file, "#{Settings.file_system.box.sina_weibo_report_root}/#{user.screen_name}"
      end
    end
  end
end
