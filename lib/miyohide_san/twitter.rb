module MiyohideSan
  module Twitter
    class Base
      include ::MiyohideSan::Zapierable

      def initialize(event)
        @event = event
      end

      def url
        Settings.zapier.twitter
      end

      def json
        { body: body }.to_json
      end
    end

    class NewEvent < Base
      def body
        "#{@event.formatted_starts_at}（#{@event.weekday}）開催予定の #{@event.title} の募集を開始したので、よろしければぜひ。参加登録は以下からお願いします。#{Settings.twitter.hashtag}\n #{@event.public_url}"
      end
    end

    class RecentEvent < Base
      def body
        "#{@event.formatted_starts_at}（#{@event.weekday}）に #{@event.title} を開催しますので、よろしければぜひ。参加登録は以下からお願いします。#{Settings.twitter.hashtag}\n #{@event.public_url}"
      end
    end
  end
end
