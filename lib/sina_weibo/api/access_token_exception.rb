module SinaWeibo
  module Api
    class AccessTokenException < ::SinaWeibo::Api::Exception
      def initialize
        super 'Access token exception'
      end
    end
  end
end
