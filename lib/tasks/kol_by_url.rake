# :encoding => utf-8

namespace :kol_by_url do
  task :grab, [:file_path] => :environment do |t, args|
    if defined?(Rails) && (Rails.env == 'development')
      Rails.logger = Logger.new(STDOUT)
    end

    report_file = nil

    api = SinaWeibo::Api::ShortUrlRequest.new Settings.app.sina_weibo_access_token

    Axlsx::Package.new do |ap|
      ap.workbook do |book|
        book.add_worksheet name: 'kols' do |sheet|
          sheet.add_row ['名字', '微博账户地址', '发布链接', '发布时间', '微博内容']
          File.open(args.file_path, 'rb') do |file|
            content = file.read
            content.split(';').each_with_index do |line, index|
              result = api.share_statuses line.strip
              go = Go.find_by_sina_weibo_shorten_url line.strip
              if result["share_statuses"] && result["share_statuses"].is_a?(Array)
                result["share_statuses"].each do |status_data|
                  status = SinaWeibo::Entity::Status.new status_data
                  if status.is_original
                    Rails.logger.debug "** Status:"
                    Rails.logger.debug "** text:      #{status.text}"
                    Rails.logger.debug "** user:      #{status.user.screen_name}"
                    Rails.logger.debug "** user_url:  http://weibo.com/#{status.user.profile_url}"
                    Rails.logger.debug "** --------\r\n"

                    original_url = go.url if go

                    sheet.add_row [status.user.screen_name, "http://weibo.com/#{status.user.profile_url}", original_url, status.created_at.to_s(:db), status.text]
                  end
                end
              end
            end
          end
        end
      end
      report_folder = File.join Rails.root, 'tmp'
      FileUtils.mkdir_p report_folder unless File.exist?(report_folder)
      report_file = File.join report_folder, "KOL_BY_URL_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      ap.serialize report_file
      Rails.logger.info "* Created report succeed: #{report_file}"
    end

    box_uploader = ::BackOffice::Box::Uploader.new
    box_uploader.upload report_file, "微博红人报告"
  end
end


