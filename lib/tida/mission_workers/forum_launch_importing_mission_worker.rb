# :encoding => utf-8
module Tida
  module MissionWorkers
    class ForumLaunchImportingMissionWorker < ::BackOffice::MissionWorker::Base
      @queue = :retrieve_data
      def do_perform(mission)
        launches = ForumLaunch.where(mission_id: mission.id)
        Rails.logger.debug "Launches count: #{launches.count}"
        patterns = {}
        ForumChannel.all.each {|item| patterns[item.domain] = {c: item.click_pattern, r: item.reply_pattern, e: item.web_page_encoding}}
        launches.each do |launch|
          Rails.logger.debug "Importing forum launch: #{launch.url} "
          host = nil
          launch.url.scan(/http:\/\/([a-zA-Z0-9.]+)\/?.*$/) do |matches|
            host = matches[0] if matches.length
          end
          Rails.logger.debug "Host: #{host}"
          pattern = patterns[host]
          Rails.logger.debug "Pattern: #{pattern}"
          uri = URI.parse launch.url
          http = Net::HTTP.new(uri.host, uri.port)
          doc = nil
          readability_doc = nil
          if uri.scheme == 'https'
            http.use_ssl = true
          end
          begin
            if pattern && pattern[:e] == 'c'
              body = http.start { |session| session.get uri.request_uri }.body.force_encoding("gbk")
              utf8_body = Iconv.iconv("UTF-8", "GBK", body).join("")
              doc = Nokogiri::HTML(utf8_body)
              readability_doc = ::Tida::Readability::Parser.parse utf8_body
              Rails.logger.debug "Fetched c body: #{utf8_body}"
            else
              body = http.start { |session| session.get uri.request_uri }.body
              doc = Nokogiri::HTML(body)
              readability_doc = ::Tida::Readability::Parser.parse body
              Rails.logger.debug "Fetched u body: #{body}"
            end
          rescue => e
            Rails.logger.error e
            next
          end
          if pattern && pattern[:c] && pattern[:r]
            doc.xpath('//head').remove
            doc.xpath('//script').remove
            doc.xpath('//style').remove
            doc.xpath('//img').remove
            content = doc.text.gsub(/\|/, '').gsub(/\s+/, '').gsub(/：/, ':')
            Rails.logger.debug "Content: #{content}"
            click = 0
            reply = 0
            content.scan(Regexp.new(pattern[:c])) do |matches|
              click = matches[0].to_i if matches.length > 0
            end
            content.scan(Regexp.new(pattern[:r])) do |matches|
              reply = matches[0].to_i if matches.length > 0
            end
            Rails.logger.debug "Click: #{click} Reply: #{reply}"
            launch.clicks_count = click if click > 0
            Rails.logger.debug "Set click #{click}"
            launch.replies_count = reply if reply > 0
            Rails.logger.debug "Set reply #{reply}"
          end

          launch.word_amount = readability_doc.content.length
          Rails.logger.debug "Set word_amount #{launch.word_amount}"
          launch.title = readability_doc.title
          Rails.logger.debug "Set title #{launch.title}"
          launch.mission_id = nil
          Rails.logger.debug "Set mission id null"
          launch.save!
        end
      end
    end
  end
end
