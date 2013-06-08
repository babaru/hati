module SinaWeibo
  module Entity
    class User < SinaWeibo::Entity::Base
      def initialize(data)
        super(data)
      end

      def latest_status
        return SinaWeibo::Entity::Status.new data_value(:status) if data_value(:status)
        nil
      end
    end
  end
end
