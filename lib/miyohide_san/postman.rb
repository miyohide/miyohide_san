module MiyohideSan
  module Postman
    class Base
      include ::MiyohideSan::Zapierable

      def initialize(event)
        @event = event
      end

      def url
        Settings.zapier.mail
      end

      def to
        MiyohideSan::Settings.mail.to
      end

      def from
        MiyohideSan::Settings.mail.from
      end

      def body
        ERB.new(view).result(binding)
      end

      def json
        {
          to: to,
          from: from,
          subject: subject,
          body: body
        }.to_json
      end

      def view_path
        Pathname.new(File.expand_path('../views', __FILE__))
      end
    end

    class Announcement < Base
      def subject
        "#{@event.title} 募集開始のお知らせ"
      end

      def view
        File.read(view_path.join("postman/announcement.text.erb"))
      end
    end

    class PreviousNotice < Base
      def subject
        "#{@event.title} 開催のお知らせ"
      end

      def view
        File.read(view_path.join("postman/previous_notice.text.erb"))
      end
    end
  end
end
