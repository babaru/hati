module SinaWeibo
  module Retrievers
    class UserFollowersRetriever
      FOLLOWER_PAGE_SIZE = 100

      def self.retrieve(options = {})
        user_sw_id = options[:user_sw_id]
        page = options[:page]
        api = ::SinaWeibo::Api::DataRetriever.new
        response_data = api.friendships_followers user_sw_id, page * FOLLOWER_PAGE_SIZE
        users_data = response_data["users"]
        users_data.each do |user_data|
          user_entity = SinaWeibo::Entity::User.new user_data
          if block_given?
            yield ::SinaWeiboUser.create_or_update_from_entity! user_entity
          end
        end
      end
    end
  end
end
