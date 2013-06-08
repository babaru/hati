module SinaWeibo
  module Api
    class CommentDataRetriever
      attr_reader :data_retriever

      PAGE_SIZE = 50

      def initialize()
        @data_retriever = SinaWeibo::Api::DataRetriever.new
      end

      def retrieve_status_comments(options)
        status_id = options[:status_id]
        comment_count = options[:comment_count]

        Rails.logger.info "* Retrieving comments of status #{status_id}"
        total_pages = (comment_count / PAGE_SIZE.to_f).ceil
        Rails.logger.info "- There are #{total_pages} pages (#{PAGE_SIZE} per page) comments of status #{status_id}"
        1.upto(total_pages) do |page|
          response_data = data_retriever.comments_show(status_id, page)
          return if response_data.nil?
          comments_data = response_data['comments']
          Rails.logger.info "- There are #{comments_data.count} records on page #{page}"
          comments_data.each do |comment_data|
            comment = SinaWeibo::Entity::Comment.new comment_data
            if block_given?
              yield comment
            end
          end
        end

        Rails.logger.info "- All comments of status #{status_id} has been handled"
      end
    end
  end
end
