require 'RMagick'

module BackOffice
  module Captures
    class Capture
      def capture(url, filename)
        png_file = "#{filename}.png"
        jpg_file = "#{filename}.jpg"
        capture_cmd = "/usr/local/bin/phantomjs #{File.join(Rails.root, 'lib/back_office/captures/capture_phantom_script.js')} '#{url}' #{png_file}"
        Rails.logger.info "- Capture command: #{capture_cmd}"
        system capture_cmd
        Rails.logger.info "* Capture command complete"

        image = Magick::Image.read(png_file).first
        image.format = "JPG"
        image.write(jpg_file) { self.quality = 60 }
        File.delete(png_file)
        jpg_file
      end

      def batch_capture(data)
        files = []
        data.each do |item|
          Rails.logger.info "URL: #{item[:url]}, FileName: #{item[:filename]}"
          files << capture(item[:url], item[:filename])
        end
        files
      end
    end
  end
end
