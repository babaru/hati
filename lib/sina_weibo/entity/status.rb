module SinaWeibo
  module Entity
    class Status < SinaWeibo::Entity::Base
      def initialize(data)
        super(data)
      end

      def created_at
        parse_datetime(:created_at)
      end

      def user
        return SinaWeibo::Entity::User.new data_value(:user) if data_value(:user)
        nil
      end

      def original_status
        return SinaWeibo::Entity::Status.new data_value(:retweeted_status) if data_value(:retweeted_status)
        nil
      end

      def is_original
        !!data_value(:retweeted_status)
      end
    end
  end
end