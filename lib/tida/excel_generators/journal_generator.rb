# encoding: utf-8
module Tida
  module ExcelGenerators
    class JournalGenerator
      def self.generate(brand_id)
        brand = Brand.find brand_id
        diary_file = nil
        Axlsx::Package.new do |ap|
          ap.workbook do |book|
            default_font = "汉仪中等线简"
            default_font_size = 10

            color_black = 'FF000000'
            color_red = 'FFad0040'
            color_white = 'FFFFFFFF'

            center = {
              horizontal: :center,
              vertical: :center
            }

            center_bottom = {
              horizontal: :center,
              vertical: :bottom
            }

            center_top = {
              horizontal: :center,
              vertical: :top
            }

            pull_left = {
              horizontal: :left,
              vertical: :center
            }

            pull_right = {
              horizontal: :right,
              vertical: :center
            }

            styles = {
              title_cell: book.styles.add_style(
                alignment: center,
                font_name: default_font,
                sz: 12,
                border: {style: :thin, color: color_black, edges: [:top, :left, :right]},
                b: true
              ),

              title_2_cell: book.styles.add_style(
                alignment: center,
                font_name: default_font,
                sz: 12,
                border: {style: :thin, color: color_black, edges: [:left, :right]},
                b: true
              ),
              head_cell: book.styles.add_style(
                alignment: center_bottom,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black, edges: [:top, :left, :right]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),
              head_en_cell: book.styles.add_style(
                alignment: center_top,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black, edges: [:left, :right]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),
              head_2_cell: book.styles.add_style(
                alignment: center_bottom,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black, edges: [:top, :left, :right]},
                b: true
                ),
              head_2_en_cell: book.styles.add_style(
                alignment: center_top,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black, edges: [:left, :right]},
                b: true
                ),
              cell: book.styles.add_style(
                alignment: {horizontal: :left,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                wrap: true
                ),
              right_cell: book.styles.add_style(
                alignment: pull_right,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                ),
              center_cell: book.styles.add_style(
                alignment: {horizontal: :center,
                  vertical: :center},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                )
            }

            summary_sheet = nil
            book.add_worksheet name: '概况' do |sheet|
              summary_sheet = sheet
              row = sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
              row.height = 12
              row = sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", Array.new(10){nil}].flatten,
                style: [nil, Array.new(11){styles[:title_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B2:L2")
              row = sheet.add_row [nil, "监控日报概况 Overview", Array.new(10){nil}].flatten,
                style: [nil, Array.new(11) {styles[:title_2_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B3:L3")
              row = sheet.add_row [nil, "#{brand.name}网媒传播", "非#{brand.name}网媒传播", "竞品传播", "微博", nil, nil, "论坛", "博客", "问答", "视频", "问题"],
                style: [nil, Array.new(11){styles[:head_cell]}].flatten
              row.height = 15
              sheet.merge_cells("E4:G4")
              row = sheet.add_row [nil, "#{brand.name}", "Non #{brand.name}", "Competitors", "Weibos", nil, nil, "Forums", "Blogs", "Q&A", "Videos", "Issues"],
                style: [nil, Array.new(11){styles[:head_en_cell]}].flatten
              row.height = 15
              sheet.merge_cells("E5:G5")
              row = sheet.add_row [nil, "总数", "总数", "总数", "总微博数", "总转发数", "总评论数", "总数", "总数", "总数", "总数", "总数"],
                style: [nil, Array.new(11){styles[:head_2_cell]}].flatten
              row.height = 15
              row = sheet.add_row [nil, "Total", "Total", "Total", "Status", "Repost", "Comment", "Total", "Total", "Total", "Total", "Total"],
                style: [nil, Array.new(11){styles[:head_2_en_cell]}].flatten
              row.height = 15
            end

            page_summary_data = []
            media_total_count = 0
            other_media_total_count = 0
            contest_total_count = 0
            weibo_status_count = 0
            weibo_repost_count = 0
            weibo_comment_count = 0
            forum_total_count = 0
            blog_total_count = 0
            qa_total_count = 0
            video_total_count = 0

            book.add_worksheet name: "#{brand.name}网媒传播监测（原发和转载）" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              row = sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B2:M2")
              row = sheet.add_row [nil, "#{brand.name}网媒传播监测（原发和转载）#{brand.name} Web Media Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_2_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B3:M3")

              row = sheet.add_row [nil, "序号", "日期", "标题", "地址", "区域", "媒体名称", "媒体等级", "版位", "显著性", "字数", "基调", "广告价值 (元)"],
              style: [nil, Array.new(12) {styles[:head_cell]}].flatten
              row.height = 15
              row = sheet.add_row [nil, "No.", "Date", "Title", "URL", "Area", "Media Name", "Media Level", "Position", "Significant", "Alphanumeric", "Tone", "Value (RMB)"],
              style: [nil, Array.new(12) {styles[:head_en_cell]}].flatten
              row.height = 15

              launches = Launch.where("brand_id=? and date(launched_at) >= ? and date(launched_at) <= ? and type = ?", brand_id, Time.now.beginning_of_month.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), "MediaLaunch").order('launched_at DESC, created_at DESC')
              launches.each_with_index do |launch, index|
                if launch.channel
                  row = sheet.add_row [nil, index + 1, launch.launched_at.strftime("%Y年%m月%d日"), launch.title, launch.url, launch.channel.region, launch.channel.name, MediaEvaluator.level(launch.channel.level), MediaEvaluator.position(launch.media_position_id), MediaEvaluator.significant(launch.media_position_id, launch.channel.level), nil, "Positive", nil],
                    style: [nil, Array.new(6) {styles[:cell]}, styles[:center_cell], styles[:center_cell], styles[:center_cell], styles[:right_cell], styles[:center_cell], styles[:right_cell]].flatten
                  row.height = 28
                end
              end
              media_total_count = launches.count

              sheet.column_widths 2, 5, 14, 50, 50, 10, 15, 12, 15, 10, 12, 10, 15
            end

            book.add_worksheet name: "非#{brand.name}网媒传播监测（原发和转载）" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              row = sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B2:M2")
              row = sheet.add_row [nil, "非#{brand.name}网媒传播监测（原发和转载）No #{brand.name} Web Media Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_2_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B3:M3")

              row = sheet.add_row [nil, "序号", "日期", "标题", "地址", "区域", "媒体名称", "媒体等级", "版位", "显著性", "字数", "基调", "广告价值 (元)"],
              style: [nil, Array.new(12) {styles[:head_cell]}].flatten
              row.height = 15
              row = sheet.add_row [nil, "No.", "Date", "Title", "URL", "Area", "Media Name", "Media Level", "Position", "Significant", "Alphanumeric", "Tone", "Value (RMB)"],
              style: [nil, Array.new(12) {styles[:head_en_cell]}].flatten
              row.height = 15

              records = JournalRecord.where("brand_id=? and date(published_at) >= ? and date(published_at) <= ? and type = ?", brand_id, Time.now.beginning_of_month.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), "MediaJournalRecord").order('published_at DESC')

              if records.count == 0
                row = sheet.add_row [nil, "无发现", Array.new(11){nil}].flatten,
                  style: [nil, Array.new(12) {styles[:cell]}].flatten
                row.height = 28
                sheet.merge_cells("B4:M4")
              else
                records.each_with_index do |record, index|
                  data = record.data
                  row = sheet.add_row [nil, index + 1, data[:date], data[:title], data[:url], nil, data[:source], Array.new(6) {nil}].flatten,
                    style: [nil, Array.new(12) {styles[:cell]}].flatten
                  row.height = 28
                end
                other_media_total_count = records.count
              end

              sheet.column_widths 2, 5, 14, 50, 50, 10, 15, 12, 15, 10, 12, 10, 15
            end

            book.add_worksheet name: "竞品每日监测" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              row = sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B2:M2")
              row = sheet.add_row [nil, "竞品每日监测 Competitors Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_2_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B3:M3")

              row = sheet.add_row [nil, "序号", "日期", "标题", "地址", "区域", "媒体名称", "媒体等级", "版位", "显著性", "字数", "基调", "广告价值 (元)"],
              style: [nil, Array.new(12) {styles[:head_cell]}].flatten
              row.height = 15
              row = sheet.add_row [nil, "No.", "Date", "Title", "URL", "Area", "Media Name", "Media Level", "Position", "Significant", "Alphanumeric", "Tone", "Value (RMB)"],
              style: [nil, Array.new(12) {styles[:head_en_cell]}].flatten
              row.height = 15

              records = JournalRecord.where("brand_id=? and date(published_at) >= ? and date(published_at) <= ? and type = ?", brand_id, Time.now.beginning_of_month.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), "ContestJournalRecord").order('published_at DESC')

              if records.count == 0
                row = sheet.add_row [nil, "无发现", Array.new(11){nil}].flatten,
                  style: [nil, Array.new(12) {styles[:cell]}].flatten
                row.height = 28
                sheet.merge_cells("B4:M4")
              else
                records.each_with_index do |record, index|
                  data = record.data
                  row = sheet.add_row [nil, index + 1, data[:date], data[:title], data[:url], nil, data[:source], Array.new(6) {nil}].flatten,
                    style: [nil, Array.new(12) {styles[:cell]}].flatten
                  row.height = 28
                end
                contest_total_count = records.count
              end

              sheet.column_widths 2, 5, 14, 50, 50, 10, 15, 12, 15, 10, 12, 10, 15
            end

            book.add_worksheet name: "互动渠道传播监测" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              row = sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B2:M2")
              row = sheet.add_row [nil, "微博渠道传播监测（转发Top5）Weibo Monitoring (Reposts Top 5)", Array.new(11) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:title_2_cell]}].flatten
              row.height = 30
              sheet.merge_cells("B3:M3")

              row = sheet.add_row [nil, "序号", "日期", "微博内容", nil, nil, nil, nil, "区域", "用户名称 Name", "粉丝数", "转发数", "评论数"],
              style: [nil, Array.new(12) {styles[:head_cell]}].flatten
              row.height = 15
              sheet.merge_cells("D4:H4")
              row = sheet.add_row [nil, "No.", "Date", "Status", nil, nil, nil, nil, "Area", "Screen Name", "Fans", "Repost Count", "Comment Count"],
              style: [nil, Array.new(12) {styles[:head_en_cell]}].flatten
              row.height = 15
              sheet.merge_cells("D5:H5")

              result = JournalRecord.connection.select_all("select count(*) as total_count, sum(retweets_count) as total_retweets_count, sum(comments_count) as total_comments_count from journal_records where brand_id=#{brand_id} and date(published_at) >= '#{Time.now.beginning_of_month.strftime("%Y-%m-%d")}' and date(published_at) <= '#{Time.now.strftime("%Y-%m-%d")}' and type = 'WeiboJournalRecord'")
              weibo_status_count = result[0]["total_count"]
              weibo_repost_count = result[0]["total_retweets_count"]
              weibo_comment_count = result[0]["total_comments_count"]

              weibo_status_count ||= 0
              weibo_repost_count ||= 0
              weibo_comment_count ||= 0

              result = Launch.connection.select_all("select count(*) as total_count, sum(retweets_count) as total_retweets_count, sum(comments_count) as total_comments_count from launches where brand_id=6 and date(launched_at) >= '#{Time.now.beginning_of_month.strftime("%Y-%m-%d")}' and date(launched_at) <= '#{Time.now.strftime("%Y-%m-%d")}' and type = 'WeiboLaunch'")
              weibo_status_count += result[0]["total_count"] if result.length > 0 && result[0]["total_count"]
              weibo_repost_count += result[0]["total_retweets_count"] if result.length > 0 && result[0]["total_retweets_count"]
              weibo_comment_count += result[0]["total_comments_count"] if result.length > 0 && result[0]["total_comments_count"]

              weibo_array = Array.new
              top5launches = Launch.where("brand_id=? and date(launched_at) >= ? and date(launched_at) <= ? and type = ?", brand_id, Time.now.beginning_of_month.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), "WeiboLaunch").order('retweets_count DESC, comments_count DESC, sw_created_at DESC').limit(5)
              top5launches.each do |launch|
                weibo_array << {
                  user_name: launch.sina_weibo_status.sina_weibo_user.screen_name,
                  location: launch.sina_weibo_status.sina_weibo_user.location,
                  followers_count: launch.sina_weibo_status.sina_weibo_user.followers_count,
                  created_at: launch.sina_weibo_status.sw_created_at.strftime('%Y-%m-%d'),
                  retweets_count: launch.retweets_count,
                  comments_count: launch.comments_count,
                  body: launch.title
                }
              end
              records = JournalRecord.where("brand_id=? and date(published_at) >= ? and date(published_at) <= ? and type = ?", brand_id, Time.now.beginning_of_month.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), "WeiboJournalRecord").order('retweets_count DESC, comments_count DESC, published_at DESC').limit(5)
              records.each do |record|
                data = record.data
                weibo_array << {
                  user_name: data[:user],
                  location: data[:region],
                  followers_count: data[:fans_count],
                  created_at: data[:date],
                  retweets_count: data[:retweets_count],
                  comments_count: data[:comments_count],
                  body: data[:body]
                }
              end

              weibo_array = weibo_array.sort {|x, y| y[:retweets_count] <=> x[:retweets_count] }
              weibo_array = weibo_array[0, [5, weibo_array.length].min]

              if weibo_array.length == 0
                row = sheet.add_row [nil, "无发现", Array.new(11) {nil}].flatten,
                  style: [nil, Array.new(12) {styles[:cell]}].flatten
                row.height = 28
                sheet.merge_cells("B6:M6")
              else
                weibo_array.each_with_index do |record, index|
                  record[:created_at] = Date.parse(record[:created_at]) if record[:created_at].is_a?(String)
                  row = sheet.add_row [nil, index + 1, record[:created_at].strftime("%Y年%m月%d日"), record[:body], nil, nil, nil, nil, record[:location], record[:user_name], record[:followers_count], record[:retweets_count], record[:comments_count]],
                    style: [nil, Array.new(12) {styles[:cell]}].flatten
                  row.height = 28
                  sheet.merge_cells("D#{index + 6}:H#{index + 6}")
                end
              end

              forum_total_count = JournalGenerator.add_journal_record_block sheet, "论坛渠道传播监控 Forum Monitoring", "ForumJournalRecord", brand, styles
              blog_total_count = JournalGenerator.add_journal_record_block sheet, "博客渠道传播监控 Blog Monitoring", "BlogJournalRecord", brand, styles
              qa_total_count = JournalGenerator.add_journal_record_block sheet, "问答渠道传播监控 Q&A Monitoring", "QAJournalRecord", brand, styles
              video_total_count = JournalGenerator.add_journal_record_block sheet, "视频渠道传播监控 Video Monitoring", "VideoJournalRecord", brand, styles

              sheet.column_widths 2, 5, 14, 50, 50, 10, 15, 10, 15, 15, 12, 10, 15
            end

            page_summary_data << media_total_count
            page_summary_data << other_media_total_count
            page_summary_data << contest_total_count
            page_summary_data << weibo_status_count
            page_summary_data << weibo_repost_count
            page_summary_data << weibo_comment_count
            page_summary_data << forum_total_count
            page_summary_data << blog_total_count
            page_summary_data << qa_total_count
            page_summary_data << video_total_count

            row = summary_sheet.add_row [nil, page_summary_data, nil].flatten,
              style: [nil, Array.new(11){styles[:right_cell]}].flatten
            row.height = 30

            row = summary_sheet.add_row [nil], style: [nil]
            row.height = 30

            row = summary_sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], style: [nil, Array.new(12) {styles[:title_cell]}].flatten
            row.height = 30
            summary_sheet.merge_cells("B#{row.index + 1}:M#{row.index + 1}")
            row = summary_sheet.add_row [nil, "问题汇总 Issues Overview", Array.new(11) {nil}].flatten, style: [nil, Array.new(12) {styles[:title_2_cell]}].flatten
            row.height = 30
            summary_sheet.merge_cells("B#{row.index + 1}:M#{row.index + 1}")

            row = summary_sheet.add_row [nil, "日期", "来源", "标题", nil, nil, nil, "地址", nil, nil,"处理建议", "客户反馈", "处理时间"],
              style: [nil, Array.new(12) {styles[:head_cell]}].flatten
            row.height = 15
            summary_sheet.merge_cells("D#{row.index + 1}:G#{row.index + 1}")
            summary_sheet.merge_cells("H#{row.index + 1}:J#{row.index + 1}")
            row = summary_sheet.add_row [nil, "Date", "Source", "Title", nil, nil, nil, "URL", nil, nil,"Suggestion", "Feedback", "Time"],
              style: [nil, Array.new(12) {styles[:head_en_cell]}].flatten
            row.height = 15
            summary_sheet.merge_cells("D#{row.index + 1}:G#{row.index + 1}")
            summary_sheet.merge_cells("H#{row.index + 1}:J#{row.index + 1}")

            summary_sheet.column_widths 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
          end

          diary_folder = File.join Rails.root, Settings.file_system.journal_report
          FileUtils.mkdir_p diary_folder unless File.exist?(diary_folder)
          diary_file = File.join diary_folder, "#{brand.name} EPR全网监控日报#{Time.now.strftime("%Y%m%d")} 百孚思 #{Time.now.strftime("%H%M%S")}.xlsx"
          ap.serialize diary_file
          Rails.logger.debug "* Saved to #{diary_file}"
        end

        box_uploader = ::BackOffice::Box::Uploader.new
        box_uploader.upload diary_file, "#{Settings.file_system.box.journal_report}/#{brand.name}"
      end

      def self.add_journal_record_block(sheet, name, type, brand, styles)
        row = sheet.add_row [nil], style: nil
        row.height = 30

        row = sheet.add_row [nil, "#{brand.name} EPR全网监控 #{brand.name} EPR Web Monitoring", Array.new(11) {nil}].flatten,
        style: [nil, Array.new(12) {styles[:title_cell]}].flatten
        row.height = 30
        sheet.merge_cells("B#{row.index + 1}:M#{row.index + 1}")
        row = sheet.add_row [nil, name, Array.new(11) {nil}].flatten,
        style: [nil, Array.new(12) {styles[:title_2_cell]}].flatten
        row.height = 30
        sheet.merge_cells("B#{row.index + 1}:M#{row.index + 1}")

        row = sheet.add_row [nil, "序号", "日期", "标题", "地址", "区域", "媒体名称", "媒体等级", "版位", "显著性", "字数", "基调", "广告价值 (元)"],
        style: [nil, Array.new(12) {styles[:head_cell]}].flatten
        row.height = 15
        row = sheet.add_row [nil, "No.", "Date", "Title", "URL", "Area", "Media Name", "Media Level", "Position", "Significant", "Alphanumeric", "Tone", "Value (RMB)"],
        style: [nil, Array.new(12) {styles[:head_en_cell]}].flatten
        row.height = 15

        records = JournalRecord.where("brand_id=? and date(published_at) >= ? and date(published_at) <= ? and type = ?", brand.id, Time.now.beginning_of_month.strftime("%Y-%m-%d"), Time.now.strftime("%Y-%m-%d"), type).order('published_at DESC')
        total_count = 0

        if records.count == 0
          row = sheet.add_row [nil, "无发现", Array.new(11){nil}].flatten,
            style: [nil, Array.new(12) {styles[:cell]}].flatten
          row.height = 28
          sheet.merge_cells("B#{row.index + 1}:M#{row.index + 1}")
        else
          records.each_with_index do |record, index|
            data = record.data
            row = sheet.add_row [nil, index + 1, data[:date], data[:title], data[:url], nil, data[:source], Array.new(6) {nil}].flatten,
              style: [nil, Array.new(12) {styles[:cell]}].flatten
            row.height = 28
          end
          total_count = records.count
        end
        total_count
      end
    end
  end
end
