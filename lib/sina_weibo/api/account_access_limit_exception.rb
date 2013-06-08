module SinaWeibo
  module Api
    class AccountAccessLimitException < AccessTokenException
      def initialize
        super 'Reached account access limit'
      end
    end
  end
end
