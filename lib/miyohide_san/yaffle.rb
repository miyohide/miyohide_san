module MiyohideSan
  class Yaffle
    def initialize(event)
      @event = event
      @client = Twitter::REST::Client.new(Settings.tweet)
    end

    def tweet
      @client.update(message)
    end

    def message
      "#{@event.date}（#{@event.weekday}）に #{@event.title} を開催しますので、よろしければぜひ。参加登録は以下からお願いします。#yokohamarb\n #{@event.public_url}"
    end
  end
end
