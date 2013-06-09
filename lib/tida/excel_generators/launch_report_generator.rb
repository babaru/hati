# encoding: utf-8
module Tida
  module ExcelGenerators
    class LaunchReportGenerator
      def self.generate(brand_id)
        brand = Brand.find brand_id
        diary_file = nil
        Axlsx::Package.new do |ap|
          ap.workbook do |book|
            default_font = "汉仪中等线简"
            default_font_size = 10

            color_black = 'FF000000'
            color_red = 'FFad0040'
            color_gold = 'FFc4b7a6'
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
              title_first_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:top, :left]},
                b: true
              ),

              title_last_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:top, :right]},
                b: true
              ),

              title_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:top]},
                b: true
              ),

              title_2_first_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:left]},
                b: true
              ),

              title_2_last_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:right]},
                b: true
              ),

              title_2_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                b: true
              ),

              title_3_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 10
              ),

              head_first_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:top, :left, :bottom]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              head_last_cell: book.styles.add_style(
                alignment: pull_right,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:top, :right, :bottom]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              head_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: 12,
                border: {style: :medium, color: color_black, edges: [:top, :bottom]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              column_head_first_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom, :left]},
                bg_color: color_gold,
                fg_color: color_black,
                b: true
                ),

              column_head_last_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom, :right]},
                bg_color: color_gold,
                fg_color: color_black,
                b: true
                ),

              column_head_cell: book.styles.add_style(
                alignment: pull_left,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom]},
                bg_color: color_gold,
                fg_color: color_black,
                b: true
                ),

              column_head_first_cell_2: book.styles.add_style(
                alignment: center_bottom,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :left]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              column_head_last_cell_2: book.styles.add_style(
                alignment: center_bottom,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :right]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              column_head_cell_2: book.styles.add_style(
                alignment: center_bottom,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              column_head_first_cell_2_en: book.styles.add_style(
                alignment: center_top,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:bottom, :left]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              column_head_last_cell_2_en: book.styles.add_style(
                alignment: center_top,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:bottom, :right]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              column_head_cell_2_en: book.styles.add_style(
                alignment: center_top,
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:bottom]},
                bg_color: color_red,
                fg_color: color_white,
                b: true
                ),

              first_cell: book.styles.add_style(
                alignment: {horizontal: :left,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                border_left: {style: :medium, color: color_black},
                wrap: true
                ),

              last_cell: book.styles.add_style(
                alignment: {horizontal: :left,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                border_right: {style: :medium, color: color_black},
                wrap: true
                ),

              last_right_cell: book.styles.add_style(
                alignment: {horizontal: :right,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                border_right: {style: :medium, color: color_black},
                wrap: true
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
                alignment: {horizontal: :right,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :thin, color: color_black},
                wrap: true
                ),

              first_bottom_cell: book.styles.add_style(
                alignment: {horizontal: :left,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom, :left]},
                wrap: true,
                b: true
                ),

              last_bottom_cell: book.styles.add_style(
                alignment: {horizontal: :left,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom, :right]},
                wrap: true,
                b: true
                ),

              last_bottom_right_cell: book.styles.add_style(
                alignment: {horizontal: :right,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom, :right]},
                wrap: true,
                b: true
                ),

              bottom_cell: book.styles.add_style(
                alignment: {horizontal: :left,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom]},
                wrap: true,
                b: true
                ),

              bottom_right_cell: book.styles.add_style(
                alignment: {horizontal: :right,
                  vertical: :center, wrapText: true},
                font_name: default_font,
                sz: default_font_size,
                border: {style: :medium, color: color_black, edges: [:top, :bottom]},
                wrap: true,
                b: true
                )
            }

            summary_sheet = nil
            book.add_worksheet name: '概况' do |sheet|
              summary_sheet = sheet

              row = sheet.add_row [nil, nil, nil, nil, nil, nil]
              row.height = 15

              # Title
              row = sheet.add_row [nil, nil, "#{brand.name} EPR日报 #{brand.name} EPR Daily Report", nil, nil, nil],
                style: [nil, styles[:title_first_cell], styles[:title_cell], styles[:title_cell], styles[:title_cell], styles[:title_last_cell]]
              row.height = 24
              row = sheet.add_row [nil, nil, "概况 Overview", nil, nil, nil],
                style: [nil, styles[:title_2_first_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_last_cell]]
              row.height = 24
              row = sheet.add_row [nil, nil, nil, nil, nil, nil],
                style: [nil, styles[:title_2_first_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_last_cell]]
              row.height = 10
              row = sheet.add_row [nil, nil, Time.now.strftime('%Y-%m-%d'), nil, nil, nil],
                style: [nil, styles[:title_2_first_cell], styles[:title_3_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_last_cell]]
              row.height = 24
              row = sheet.add_row [nil, nil, "百孚思", nil, nil, nil],
                style: [nil, styles[:title_2_first_cell], styles[:title_3_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_last_cell]]
              row.height = 24
              row = sheet.add_row [nil, nil, nil, nil, nil, nil],
                style: [nil, styles[:title_2_first_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_cell], styles[:title_2_last_cell]]
              row.height = 10

              result = Launch.connection.select_all("select count(*) as total_count, sum(media_value) as total_media_value from launches where brand_id=#{brand_id} and launched_at >= '#{Time.now.beginning_of_month.utc.strftime("%Y-%m-%d %H:%M:%S")}' and date(launched_at) <= '#{Time.now.utc.strftime("%Y-%m-%d")}' and type in ('MediaLaunch', 'PressReleaseLaunch', 'PassIssueLaunch')")
              media_total_count = result[0]["total_count"]
              media_total_value = result[0]["total_media_value"]

              result = query_launch(brand_id, 'MediaLaunch', "count(*) as total_count, sum(media_value) as total_media_value", "and ad_style_id=1")
              media_focus_pic_total_count = result[0]["total_count"]
              media_focus_pic_total_value = result[0]["total_media_value"]

              result = query_launch(brand_id, 'MediaLaunch', "count(*) as total_count, sum(media_value) as total_media_value", "and ad_style_id=2")
              media_text_link_total_count = result[0]["total_count"]
              media_text_link_total_value = result[0]["total_media_value"]

              result = query_launch(brand_id, 'MediaLaunch', "count(*) as total_count, sum(media_value) as total_media_value", "and ad_style_id=3")
              media_other_total_count = result[0]["total_count"]
              media_other_total_value = result[0]["total_media_value"]

              result = Launch.connection.select_all("select count(*) as total_count, sum(replies_count) as total_replies_count, sum(clicks_count) as total_clicks_count from launches where brand_id=#{brand_id} and launched_at >= '#{Time.now.beginning_of_month.utc.strftime("%Y-%m-%d %H:%M:%S")}' and date(launched_at) <= '#{Time.now.utc.strftime("%Y-%m-%d")}' and type = 'ForumLaunch'")
              forum_total_count = result[0]["total_count"]
              forum_total_click_count = result[0]["total_clicks_count"]
              forum_total_reply_count = result[0]["total_replies_count"]

              result = Launch.connection.select_all("select count(*) as total_count, sum(retweets_count) as total_retweets_count, sum(comments_count) as total_comments_count from launches where brand_id=#{brand_id} and launched_at >= '#{Time.now.beginning_of_month.utc.strftime("%Y-%m-%d %H:%M:%S")}' and date(launched_at) <= '#{Time.now.utc.strftime("%Y-%m-%d")}' and type = 'WeiboLaunch'")
              weibo_status_count = result[0]["total_count"]
              weibo_repost_count = result[0]["total_retweets_count"]
              weibo_comment_count = result[0]["total_comments_count"]

              # Summary
              row = sheet.add_row [nil, "#{brand.name} 原创 #{brand.name} Communication", nil, nil, nil, Time.now.strftime('%Y-%m-%d')],
                style: [nil, styles[:head_first_cell], styles[:head_cell], styles[:head_cell], styles[:head_cell], styles[:head_last_cell]]
              row.height = 24
              row = sheet.add_row [nil, "类型 Type", "落地执行 Executions", nil, "数量 Quantity", "媒体价值(元) Media Value(RMB)"],
                style: [nil, styles[:column_head_first_cell], styles[:column_head_cell], styles[:column_head_cell], styles[:column_head_cell], styles[:column_head_last_cell]]
              row.height = 18

              row = sheet.add_row [nil, "新闻稿 PR", "#{brand.name}发布 #{brand.name} Executions", "总数 Amount", media_total_count, media_total_value],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "首页焦点图 Front Page Pictures", media_focus_pic_total_count, media_focus_pic_total_value],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "要闻文字链 Important Area Links", media_text_link_total_count, media_text_link_total_value],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "其他文字链 Other Area Links", media_other_total_count, media_other_total_value],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18

              row = sheet.add_row [nil, "社会化媒体 Social Media", "微博 Weibo", "原发微博数 Weibo Status Amount", weibo_status_count, "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "转发数 Repost Amount", weibo_repost_count, "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "评论数 Comment Amount", weibo_comment_count, "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, "论坛 Forum", "帖子数 Post Amount", forum_total_count, "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "点击数 Click Amount", forum_total_click_count, "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, nil, "回复数 Reply Amount", forum_total_reply_count, "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, "博客 Blog", nil, "0", "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, "问答 Q&A", nil, "0", "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18
              row = sheet.add_row [nil, nil, "视频 Video", nil, "0", "0"],
                style: [nil, styles[:first_cell], styles[:cell], styles[:cell], styles[:right_cell], styles[:last_right_cell]]
              row.height = 18

              row = sheet.add_row [nil, nil, nil, nil, "总计 Total", "0"],
                style: [nil, styles[:first_bottom_cell], styles[:bottom_cell], styles[:bottom_cell], styles[:bottom_right_cell], styles[:last_bottom_right_cell]]
              row.height = 18

              sheet.column_widths 2, 18, 20, 28, 18, 30
            end

            book.add_worksheet name: "#{brand.name}网媒传播监测 #{brand.name} Communication" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              add_title(sheet, "#{brand.name}网媒传播监测（原发和转载）#{brand.name} Communication", brand, styles, 13)

              row = sheet.add_row [nil, "序号", "日期", "标题", "地址", "区域", "媒体名称", "媒体等级", "版位", "显著性", "字数", "基调", "媒体价值 (元)"],
              style: [nil, styles[:column_head_first_cell_2], Array.new(10) {styles[:column_head_cell_2]}, styles[:column_head_last_cell_2]].flatten
              row.height = 15
              row = sheet.add_row [nil, "No.", "Date", "Title", "URL", "Area", "Media Name", "Media Level", "Position", "Significant", "Alphanumeric", "Tone", "Value (RMB)"],
              style: [nil, styles[:column_head_first_cell_2_en], Array.new(10) {styles[:column_head_cell_2_en]}, styles[:column_head_last_cell_2_en]].flatten
              row.height = 15
              row.height = 15

              launches = Launch.where({
                brand_id: brand_id,
                launched_at: (Time.now.beginning_of_month.utc..Time.now.utc),
                type: ["MediaLaunch", "PressReleaseLaunch", "PassIssueLaunch"]}).order('group_title ASC, launched_at DESC, created_at DESC')

              launches.each_with_index do |launch, index|
                channel_name, channel_region, channel_level = nil, nil, 0
                channel_name, channel_region, channel_level = launch.channel.name, launch.channel.region, launch.channel.level if launch.channel
                row = sheet.add_row [nil, index + 1, launch.launched_at.strftime("%Y年%m月%d日"), launch.title, launch.url, channel_region, channel_name, MediaEvaluator.level(channel_level), MediaEvaluator.position(launch.media_position_id), MediaEvaluator.significant(launch.media_position_id, channel_level), launch.word_amount, "Positive", launch.media_value],
                  style: [nil, styles[:first_cell], Array.new(10) {styles[:cell]}, styles[:last_cell]].flatten
                row.height = 18
              end
              media_total_count = launches.count

              sheet.column_widths 2, 5, 14, 50, 50, 10, 15, 12, 15, 10, 12, 10, 15
            end

            book.add_worksheet name: "#{brand.name}论坛传播 #{brand.name} Forum" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              add_title(sheet, "#{brand.name}论坛传播 #{brand.name} Forum", brand, styles, 8)

              group_title = nil

              launches = Launch.where({
                brand_id: brand_id,
                launched_at: (Time.now.beginning_of_month.utc..Time.now.utc),
                type: "ForumLaunch"}).order('group_title ASC, launched_at DESC, created_at DESC')

              launches.each_with_index do |launch, index|
                if group_title != launch.group_title || index == 0
                  row = sheet.add_row [nil, "序号", "日期", "媒体名称", "版位", "地址", "回复", "点击"],
                  style: [nil, styles[:column_head_first_cell_2], Array.new(5) {styles[:column_head_cell_2]}, styles[:column_head_last_cell_2]].flatten
                  row.height = 15
                  row = sheet.add_row [nil, "No.", "Date", "Media Name", "Position", "URL", "Reply", "Click"],
                  style: [nil, styles[:column_head_first_cell_2_en], Array.new(5) {styles[:column_head_cell_2_en]}, styles[:column_head_last_cell_2_en]].flatten
                  row.height = 15
                  row.height = 15

                  result = Launch.connection.select_all("SELECT SUM(REPLIES_COUNT) AS sum_replies_count, SUM(CLICKS_COUNT) AS sum_clicks_count FROM launches WHERE group_title = '#{launch.group_title}'")
                  sum_replies_count, sum_clicks_count = 0, 0
                  sum_replies_count = result[0]['sum_replies_count']
                  sum_clicks_count = result[0]['sum_clicks_count']

                  row = sheet.add_row [nil, "标题", nil, launch.group_title, nil, nil, sum_replies_count, sum_clicks_count],
                    style: [nil, styles[:column_head_first_cell_2], Array.new(5) {styles[:column_head_cell_2]}, styles[:column_head_last_cell_2]].flatten
                  row.height = 15
                  sheet.merge_cells("B#{row.index + 1}:C#{row.index + 1}")
                  sheet.merge_cells("D#{row.index + 1}:F#{row.index + 1}")

                  row = sheet.add_row [nil, "Title", nil, nil, nil, nil, nil, nil],
                    style: [nil, styles[:column_head_first_cell_2_en], Array.new(5) {styles[:column_head_cell_2_en]}, styles[:column_head_last_cell_2_en]].flatten
                  row.height = 15
                  sheet.merge_cells("B#{row.index + 1}:C#{row.index + 1}")
                  sheet.merge_cells("D#{row.index + 1}:F#{row.index + 1}")
                end
                group_title = launch.group_title
                Rails.logger.debug "#{group_title}"
                Rails.logger.debug "#{launch.group_title}"

                channel_name, channel_region, channel_level = nil, nil, 0
                channel_name, channel_region, channel_level = launch.channel.name, launch.channel.region, launch.channel.level if launch.channel
                row = sheet.add_row [nil, index + 1, launch.launched_at.strftime("%Y年%m月%d日"), channel_name, launch.section, launch.url, launch.replies_count, launch.clicks_count],
                  style: [nil, styles[:first_cell], Array.new(5) {styles[:cell]}, styles[:last_cell]].flatten
                row.height = 18
              end

              sheet.column_widths 2, 5, 14, 15, 15, 50, 8, 8
            end

            book.add_worksheet name: "#{brand.name}微博传播 #{brand.name} Weibo" do |sheet|
              row = sheet.add_row [nil], style: nil
              row.height = 12

              add_title(sheet, "#{brand.name}微博传播 #{brand.name} Weibo", brand, styles, 10)

              row = sheet.add_row [nil, "序号", "日期", "内容", "地址", "转发数", "评论数", "微博帐号", "地域", "粉丝数"],
              style: [nil, styles[:column_head_first_cell_2], Array.new(7) {styles[:column_head_cell_2]}, styles[:column_head_last_cell_2]].flatten
              row.height = 15
              row = sheet.add_row [nil, "No.", "Date", "Content", "URL", "Repost", "Comment", "User", "Location", "Fans"],
              style: [nil, styles[:column_head_first_cell_2_en], Array.new(7) {styles[:column_head_cell_2_en]}, styles[:column_head_last_cell_2_en]].flatten
              row.height = 15
              row.height = 15

              launches = Launch.where({
                brand_id: brand_id,
                launched_at: (Time.now.beginning_of_month.utc..Time.now.utc),
                type: "WeiboLaunch"}).order('launched_at DESC, created_at DESC')

              launches.each_with_index do |launch, index|
                row = sheet.add_row [nil, index + 1, launch.launched_at.strftime("%Y年%m月%d日"), launch.sina_weibo_status.text, launch.url, launch.sina_weibo_status.reposts_count, launch.sina_weibo_status.comments_count, launch.sina_weibo_status.sina_weibo_user.screen_name, launch.sina_weibo_status.sina_weibo_user.location, launch.sina_weibo_status.sina_weibo_user.followers_count],
                  style: [nil, styles[:first_cell], Array.new(7) {styles[:cell]}, styles[:last_cell]].flatten
                row.height = 18
              end

              sheet.column_widths 2, 5, 14, 60, 40, 15, 15, 15, 15, 10
            end
          end

          diary_folder = File.join Rails.root, Settings.file_system.journal_report
          FileUtils.mkdir_p diary_folder unless File.exist?(diary_folder)
          diary_file = File.join diary_folder, "#{brand.name} EPR日报#{Time.now.strftime("%Y%m%d")} 百孚思 #{Time.now.strftime("%H%M%S")}.xlsx"
          ap.serialize diary_file
          Rails.logger.debug "* Saved to #{diary_file}"
        end

        box_uploader = ::BackOffice::Box::Uploader.new
        mission = LaunchReportGenerateMission.instance(brand_id)
        mission.report_url = box_uploader.upload diary_file, "#{Settings.file_system.box.journal_report}/#{brand.name}"
        mission.save!
        Rails.logger.debug mission.report_url
      end

      def self.add_title(sheet, name, brand, styles, column_count)
        row = sheet.add_row [nil, nil, nil, "#{brand.name} EPR日报 #{brand.name} EPR Daily Report", Array.new(column_count - 4) { nil }].flatten,
          style: [nil, styles[:title_first_cell], Array.new(column_count - 3) {styles[:title_cell]}, styles[:title_last_cell]].flatten
        row.height = 24
        row = sheet.add_row [nil, nil, nil, name, Array.new(column_count - 4) { nil }].flatten,
          style: [nil, styles[:title_2_first_cell], Array.new(column_count - 3) {styles[:title_2_cell]}, styles[:title_2_last_cell]].flatten
        row.height = 24
        row = sheet.add_row [nil, nil, nil, nil, Array.new(column_count - 4) { nil }].flatten,
          style: [nil, styles[:title_2_first_cell], Array.new(column_count - 3) {styles[:title_2_cell]}, styles[:title_2_last_cell]].flatten
        row.height = 10
        row = sheet.add_row [nil, nil, nil, Time.now.strftime('%Y-%m-%d'), Array.new(column_count - 4) { nil }].flatten,
          style: [nil, styles[:title_2_first_cell], Array.new(column_count - 3) {styles[:title_2_cell]}, styles[:title_2_last_cell]].flatten
        row.height = 24
        row = sheet.add_row [nil, nil, nil, "百孚思", Array.new(column_count - 4) { nil }].flatten,
          style: [nil, styles[:title_2_first_cell], Array.new(column_count - 3) {styles[:title_2_cell]}, styles[:title_2_last_cell]].flatten
        row.height = 24
        row = sheet.add_row Array.new(column_count) {nil},
          style: [nil, styles[:title_2_first_cell], Array.new(column_count - 3) {styles[:title_2_cell]}, styles[:title_2_last_cell]].flatten
        row.height = 10
      end

      def self.query_launch(brand_id, type, columns, other_where_clause)
        Launch.connection.select_all("select #{columns} from launches
                                                      where brand_id=#{brand_id}
                                                      and launched_at >= '#{Time.now.beginning_of_month.utc.strftime("%Y-%m-%d %H:%M:%S")}'
                                                      and date(launched_at) <= '#{Time.now.utc.strftime("%Y-%m-%d")}'
                                                      and type = '#{type}'
                                                      #{other_where_clause}")
      end
    end
  end
end
