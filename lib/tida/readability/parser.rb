# :encoding => utf-8
require 'readability'
require 'uri'
require 'net/http'
require 'net/https'
require 'ensure/encoding'

module Tida
  module Readability
    class Parser
      def self.parse(body)
        # body = ::Tida::Network::WebContentRetriever.retrieve url
        # uri = URI.parse url

        # http = Net::HTTP.new(uri.host, uri.port)
        # if uri.scheme == 'https'
        #   http.use_ssl = true
        # end
        # body = http.start { |session| session.get uri.request_uri }.body
        # utf8_body = body.ensure_encoding('UTF-8', :external_encoding => :sniff, :invalid_characters => :transcode)
        ::Readability::Document.new(body, :tags => %w[div], :attributes => %w[src href], :remove_empty_nodes => true)
      end
    end
  end
end
