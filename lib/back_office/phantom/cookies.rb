module BackOffice
  module Phantom
    class Cookies
      def refresh_capture_cookies(source)
        keys = %w(SUE SUP SUS)
        values = {}
        content = []

        keys.each do |key|
          source.scan(/^\.*weibo.com.+#{key}\s+(.+)/) do |matches|
            if matches.count > 0
              values[key] = matches.first.gsub(/\r/, '').gsub(/\n/, '')
              Rails.logger.debug "Match #{key} cookie: #{values[key]}"
              content << "phantom.addCookie({\"name\": \"#{key}\", \"value\": \"#{values[key]}\", \"domain\": \".weibo.com\", \"httponly\": true, \"secure\": false});"
            end
          end
        end

        file_content = nil
        File.open("#{Rails.root}/lib/back_office/captures/capture_phantom_script.template", 'r') {|file| file_content = file.read}
        keys.each do |key|
          file_content.gsub!(/addCookies/, content.join("\n"))
        end

        js_file = File.join(Rails.root, "lib/back_office/captures/capture_phantom_script.js")

        File.open(js_file, 'w') do |file|
          file.puts file_content
        end
      end
    end
  end
end
