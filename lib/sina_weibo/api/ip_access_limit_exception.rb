module SinaWeibo
  module Api
    class IPAccessLimitException < AccessTokenException
      def initialize
        super "Reached IP access limit"
      end
    end
  end
end
