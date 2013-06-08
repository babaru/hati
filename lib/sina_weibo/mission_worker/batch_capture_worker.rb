module SinaWeibo
  module MissionWorker
    class BatchCaptureWorker < ::BackOffice::MissionWorker::Base
      @queue = :capture
      def do_perform(mission)
        capture_worker = ::BackOffice::Captures::Capture.new
        data = []
        capture_root_folder = File.join(Rails.root, "#{Settings.file_system.capture_root}")
        capture_folder = File.join(capture_root_folder, mission.name)
        FileUtils.mkdir_p capture_folder unless Dir.exists?(capture_folder)
        mission.capture_mission_items.each_with_index do |item, index|
          data << {
            filename: File.join(capture_folder, (index + 1).to_s),
            url: item.url
          }
        end

        files = capture_worker.batch_capture data
        Rails.logger.debug "Captured files: #{files}"

        package_file = "#{capture_folder}_#{Time.now.strftime '%H%M%S'}.zip"
        zip_command = "cd #{capture_folder} && /usr/bin/zip -q -r #{package_file} ."
        Rails.logger.debug zip_command
        system zip_command

        remote_file_path = ::BackOffice::Box::Uploader.new.upload package_file, "#{Settings.file_system.box.capture_root}/#{mission.name}"
        mission.server_url = remote_file_path
        mission.save!
      end
    end
  end
end
