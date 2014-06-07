module MiyohideSan
  module Doorkeeper
    class Base
      DEFAULT_CONDITION = {
        q: "Yokohama.rb Monthly Meetup",
        page: 1,
        locale: "ja",
        sort: "starts_at"
      }.freeze

      def url
        URI::HTTP.build(params)
      end

      def response
        Net::HTTP.get_response(url).body
      end

      def self.all
        JSON.parse(self.new.response)
      end

      def self.first
        all.first
      end

      def params
        fail
      end
    end

    class RecentEvent < Base
      def params
        {
          host: "api.doorkeeper.jp",
          path: "/events",
          query: DEFAULT_CONDITION.merge({
            since: 7.days.since.utc,
            until: 8.days.since.utc
          }).to_query
        }
      end
    end

    class LastEvent < Base
      def initialize(event)
        @event = event
      end

      def params
        {
          host: "api.doorkeeper.jp",
          path: "/events",
          query: DEFAULT_CONDITION.merge({
            since: @event.starts_at.utc,
          }).to_query
        }
      end
    end

    def recent
      if json = RecentEvent.first
        json["event"]
      else
        nil
      end
    end

    module_function :recent
  end
end
