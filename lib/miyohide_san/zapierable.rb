module MiyohideSan
  module Zapierable
    def url
      fail
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def header
      { "Accept" => "application/json", "Content-type" => "application/json" }
    end

    def json
      fail
    end

    def post
      Net::HTTP.new(uri.host, uri.port).tap do |session|
        session.use_ssl = true
        session.start do |http|
          http.request_post(uri.request_uri, json, header)
        end
      end
    end
  end
end
