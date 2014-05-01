module MiyohideSan
  class Event
    THIRTY_MINUTES_AFTER = Rational(30, 24 * 60)

    def initialize(doorkeeper)
      @doorkeeper = doorkeeper
    end

    def self.find_by_after_week
      doorkeeper = Doorkeeper::Event.find(
        {
          q: "Yokohama.rb Monthly Meetup",
          page: 1,
          locale: "ja",
          sort: "starts_at",
          since: Date.today + 7,
          until: Date.today + 8
        }
      )

      doorkeeper.present? ? new(doorkeeper.first) : nil
    end

    def title
      @doorkeeper.title
    end

    def public_url
      @doorkeeper.public_url
    end

    def venue_name
      @doorkeeper.venue_name
    end

    def date
      @doorkeeper.starts_at.strftime("%Y年%m月%d日")
    end

    def starts_at
      (@doorkeeper.starts_at + THIRTY_MINUTES_AFTER).strftime("%H:%M")
    end

    def open_at
      @doorkeeper.starts_at.strftime("%H:%M")
    end

    def ends_at
      @doorkeeper.ends_at.strftime("%H:%M")
    end

    def over?
      @doorkeeper.ticket_limit < @doorkeeper.participants
    end

    def weekday
      ['日','月','火','水','木','金','土'][@doorkeeper.starts_at.strftime("%w").to_i]
    end
  end
end
