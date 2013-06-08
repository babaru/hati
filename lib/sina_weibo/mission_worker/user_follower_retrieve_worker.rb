module SinaWeibo
  module MissionWorker
    class UserFollowerRetrieveWorker < ::BackOffice::MissionWorker::RetrieveWorker
      def do_perform(mission)
        ::SinaWeibo::Api::AccessTokenProvider.reset
        context = mission.context
        user = ::SinaWeiboUser.find_by_sw_id context[:user_sw_id]
        follower_page_size = ::SinaWeibo::Retrievers::UserFollowersRetriever::FOLLOWER_PAGE_SIZE
        total_pages = (user.followers_count / follower_page_size.to_f).ceil

        (0..total_pages).each do |page|
          ::SinaWeibo::Retrievers::UserFollowersRetriever.retrieve user_sw_id: user.sw_id, page: page do |user_entity|
            user = ::SinaWeiboUser.create_or_update_from_entity! user_entity
            Rails.logger.info "- Retrieved follower @#{user.screen_name}(#{user.sw_id})"
          end

          notify mission.id, page: page
        end
      end
    end
  end
end
