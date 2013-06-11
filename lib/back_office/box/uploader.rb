module BackOffice
  module Box
    class Uploader
      attr_accessor :account
      def initialize
        account = ::Box::Account.new(Settings.box.app_key)
        auth_token = Settings.box.auth_token
        account.authorize(:auth_token => auth_token)
        unless account.authorized?
          Rails.logger.error "Unable to login, please try again."
          return
        end

        # we managed to log in successfully!
        Rails.logger.info "Logged in box.net as #{ account.login }"
        # Rails.logger.info account.auth_token

        # this is so the other example can access the account variable
        @account = account
      end

      def upload(local_file, remote_folder)
        # get the root of the folder structure
        root = @account.root

        uploading_folder = root
        remote_folder.split("/").each do |folder|
          parent_folder = uploading_folder
          unless folder.empty?
            uploading_folder = query_remote_folder folder, parent_folder
          end
        end

        temp_file = File.join File.dirname(local_file), UUID.new().generate
        uploading_file_name = File.basename local_file

        FileUtils.cp local_file, temp_file

        uploaded_file = uploading_folder.upload(temp_file)
        uploaded_file.rename uploading_file_name
        File.delete temp_file
        Rails.logger.info "* Uploaded report to box.net(#{uploaded_file.path}) succeed"

        remote_file_name = uploaded_file.share_public
        return "http://www.box.net/shared/#{remote_file_name}"
      end

      def query_remote_folder(name, root)
        folder = root.find(:type => 'folder', :name => name, :recursive => true).first
        if folder.nil?
          folder = root.create name
        end
        folder
      end
    end
  end
end
