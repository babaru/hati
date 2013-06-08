module SinaWeibo
  module Api
    class InvalidAccessTokenException < AccessTokenException
      def initialize
        super 'Invalid access token'
      end
    end
  end
end
