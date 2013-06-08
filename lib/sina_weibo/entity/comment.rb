module SinaWeibo
  module Entity
    class Comment < SinaWeibo::Entity::Base
      def initialize(data)
        super(data)
      end

      def created_at
        parse_datetime :created_at
      end

      def user
        return SinaWeibo::Entity::User.new data_value(:user) if data_value(:user)
        nil
      end

      def original_status
        return SinaWeibo::Entity::Status.new data_value(:retweeted_status) if data_value(:retweeted_status)
        nil
      end
    end
  end
end
