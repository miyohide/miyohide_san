module MiyohideSan
  module Yaffle
    class Newborn < Base
      def message
        "#{@event.date}（#{@event.weekday}）に #{@event.title} の募集を開始したので、よろしければぜひ。参加登録は以下からお願いします。#yokohamarb\n #{@event.public_url}"
      end
    end
  end
end
