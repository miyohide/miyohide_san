module MiyohideSan
  module Doorkeeper
    class Event
      PARAMS = {
        host: "api.doorkeeper.jp",
        path: "/groups/yokohamarb/events",
      }.freeze

      def url
        URI::HTTP.build(PARAMS)
      end

      def response
        Net::HTTP.get_response(url).body
      end

      def self.all
        JSON.parse(self.new.response)
      end

      def self.latest
        self.all.select {|event| DateTime.parse(event["event"]["starts_at"]) > DateTime.now }
      end
    end
  end
end
