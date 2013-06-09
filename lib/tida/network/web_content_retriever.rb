# :encoding => utf-8
require 'uri'
require 'net/http'
require 'net/https'
require 'ensure/encoding'

module Tida
  module Network
    class WebContentRetriever
      def self.retrieve(url)
        uri = URI.parse url

        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
        end
        body = http.start { |session| session.get uri.request_uri }.body
        body.ensure_encoding('UTF-8', :external_encoding => :sniff, :invalid_characters => :transcode)
      end
    end
  end
end
