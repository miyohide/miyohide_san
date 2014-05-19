module MiyohideSan
  class Postman < ActionMailer::Base
    default from: Settings.mail.from, return_path: Settings.mail.to

    def testament(event)
      @event = event
      mail to: Settings.mail.to, subject: "#{@event.title} 開催のお知らせ"
    end

    def newborn(event)
      @event = event
      mail to: Settings.mail.to, subject: "#{@event.title} 募集開始のお知らせ"
    end

    def test
      mail to: 'takahashi@1syo.net', subject: "Test mail", body: "Test mail"
    end
  end
end
