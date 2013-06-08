module SinaWeibo
  module Api
    class Exception < RuntimeError
      attr_accessor :message

      def initialize message = nil
        @message = message
      end

      def inspect
        self.message
      end

      def to_s
        inspect
      end
    end
  end
end
