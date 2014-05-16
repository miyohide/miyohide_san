module MiyohideSan
  module Yaffle
    class Testament < Base
      def message
        "#{@event.date}（#{@event.weekday}）に #{@event.title} を開催しますので、よろしければぜひ。参加登録は以下からお願いします。#yokohamarb\n #{@event.public_url}"
      end
    end
  end
end
