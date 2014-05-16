module MiyohideSan
  module Yaffle
    class Base
      def initialize(event)
        @event = event
        @client = Twitter::REST::Client.new(Settings.tweet)
      end

      def tweet
        @client.update(message)
      end

      def message
        raise StandardError, 'Messaget undefined.'
      end
    end
  end
end
