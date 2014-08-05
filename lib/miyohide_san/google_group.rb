module MiyohideSan
  module GoogleGroup
    class Base
      include ::MiyohideSan::Zapierable

      def initialize(event)
        @event = event
      end

      def url
        Settings.zapier.mail
      end

      def body
        ERB.new(view).result(binding)
      end

      def json
        {
          subject: subject,
          body: body
        }.to_json
      end

      def view
        File.read(File.expand_path("../views/#{klass.underscore}.text.erb", __FILE__))
      end

      def klass
        self.class.to_s.sub(/MiyohideSan::/, "")
      end
    end

    class NewEvent < Base
      def subject
        "#{@event.title} 募集開始のお知らせ"
      end
    end

    class RecentEvent < Base
      def subject
        "#{@event.title} 開催のお知らせ"
      end
    end
  end
end
