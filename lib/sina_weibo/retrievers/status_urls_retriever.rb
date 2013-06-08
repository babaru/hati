module SinaWeibo
  module Retrievers
    class StatusUrlsRetriever
      def self.retrieve(options = {})
        status_ids = options[:status_ids]
        api = ::SinaWeibo::Api::DataRetriever.new
        result = api.querymids status_ids
        Rails.logger.debug "encrypted_mids: #{result}"
        result.each do |encrypted_mid_data|
          encrypted_mid_data.map do |k, v|
            s = SinaWeiboStatus.find_by_sw_id k
            if s
              s.url = "http://weibo.com/#{s.sina_weibo_user.sw_id}/#{v}"
              s.encrypted_mid = v
              s.save!
            end
          end
        end
      end
    end
  end
end
