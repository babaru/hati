module SinaWeibo
  module Retrievers
    class StatusCommentsRetriever
      COMMENT_PAGE_SIZE = 50

      def self.retrieve(options = {})
        status_sw_id = options[:status_sw_id]
        page = options[:page]
        page ||= 1
        status = SinaWeiboStatus.find_by_sw_id status_sw_id

        api = ::SinaWeibo::Api::DataRetriever.new

        response_data = api.comments_show(status_sw_id, page)
        return if response_data.nil?
        comments_data = response_data['comments']
        comments_data.each do |comment_data|
          comment_entity = SinaWeibo::Entity::Comment.new comment_data
          comment = ::SinaWeiboComment.create_or_update_from_entity! comment_entity
          comment.original_status_id = status.id
          comment.original_status_sw_id = status.sw_id
          comment.save!
          if block_given?
            yield comment
          end
        end
      end
    end
  end
end
