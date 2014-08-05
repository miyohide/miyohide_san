module MiyohideSan
  module Facebook
    class Base
      include ::MiyohideSan::Zapierable

      def initialize(event)
        @event = event
      end

      def url
        Settings.zapier.facebook
      end

      def body
        ERB.new(view).result(binding)
      end

      def json
        {
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
    end

    class RecentEvent < Base
    end
  end
end
