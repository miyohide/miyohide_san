module MiyohideSan
  class Postman < ActionMailer::Base
    default from: Settings.mail.from, return_path: Settings.mail.to

    def notify(event)
      @event = event
      mail to: Settings.mail.to, subject: "#{@event.title} 開催のお知らせ"
    end
  end
end
