module MiyohideSan
  class Event
    extend Forwardable
    def_delegators :@doorkeeper, :id, :title, :public_url, :venue_name

    DEFAULT_CONDITIONS = {
      q: "Yokohama.rb Monthly Meetup",
      page: 1,
      locale: "ja",
      sort: "starts_at"
    }.freeze

    def initialize(doorkeeper)
      @doorkeeper = doorkeeper
    end

    def self.find_by_one_week_later
      doorkeeper = Doorkeeper::Event.find(
        DEFAULT_CONDITIONS.merge({
          since: Date.today + 7,
          until: Date.today + 8
        })
      )

      doorkeeper.present? ? new(doorkeeper.first) : nil
    end

    def self.latest
      doorkeeper = Doorkeeper::Event.find(DEFAULT_CONDITIONS)
      new(doorkeeper.first)
    end

    def date
      @doorkeeper.starts_at.strftime("%Y年%m月%d日")
    end

    def starts_at
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

    def new_record?
      last_event < self
    end

    def last_event
      MiyohideSan::LastEvent.new
    end
  end
end
