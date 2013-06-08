module SinaWeibo
  module ReportGenerators
    class SinaWeiboUrlPackageGenerator
      def self.generate(options = {})
        sina_weibo_url_package = SinaWeiboUrlPackage.find options[:sina_weibo_url_package_id]

        report_file = nil
        Axlsx::Package.new do |ap|
          ap.workbook do |book|
            book.add_worksheet name: 'statuses' do |sheet|
              sheet.add_row ['user', 'user url', 'status url', 'status text', 'reposts count', 'comments count', 'user location', 'verified', 'verification reason', 'followers count']
              sina_weibo_url_package.sina_weibo_statuses.each do |status|
                sheet.add_row [status.sina_weibo_user.screen_name, status.sina_weibo_user.url, status.url, status.text, status.reposts_count, status.comments_count, status.sina_weibo_user.location, status.sina_weibo_user.is_verified, status.sina_weibo_user.verified_reason, status.sina_weibo_user.followers_count]
              end
            end

            report_folder = File.join Rails.root, Settings.file_system.sina_weibo_report_root
            FileUtils.mkdir_p report_folder unless File.exist?(report_folder)
            report_file = File.join report_folder, "#{sina_weibo_url_package.name}_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
            ap.serialize report_file
            Rails.logger.info "* Created report succeed: #{report_file}"
          end
        end

        box_uploader = ::BackOffice::Box::Uploader.new
        box_uploader.upload report_file, "#{Settings.file_system.box.sina_weibo_report_root}/#{sina_weibo_url_package.name}"
      end
    end
  end
end
