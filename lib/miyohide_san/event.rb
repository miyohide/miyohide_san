module MiyohideSan
  class Event
    include Mongoid::Document

    field :title, type: String
    field :starts_at, type: DateTime
    field :ends_at, type: DateTime
    field :venue_name, type: String
    field :address, type: String
    field :ticket_limit, type: Integer
    field :published_at, type: DateTime
    field :updated_at, type: DateTime
    field :description, type: String
    field :public_url, type: String
    field :participants, type: Integer
    field :waitlisted, type: Integer

    embeds_one :group

    validates :title, presence: true

    def self.fetch!(callback = true)
      Doorkeeper::Event.latest.each do |json|
        if event = Event.where(public_url: json["event"]["public_url"]).first
          event.update_attributes!(json["event"])
        else
          Event.create!(json["event"]) do |event|
            event.new_events_notice if callback
          end
        end
      end
    end

    def self.recent!
      Event.where(starts_at: 7.days.since..8.days.since).each do |event|
        event.recent_events_notice
      end
    end

    def self.clean!
      Event.where(:starts_at.lt => Time.now).delete_all
    end

    def formatted_starts_at
      starts_at.strftime("%Y年%m月%d日")
    end

    def start_time
      starts_at.strftime("%H:%M")
    end

    def end_time
      ends_at.strftime("%H:%M")
    end

    def over?
      ticket_limit < participants
    end

    def weekday
      ['日','月','火','水','木','金','土'][starts_at.strftime("%w").to_i]
    end

    def new_events_notice
      [GoogleGroup::NewEvent, Twitter::NewEvent, FacebookGroup::NewEvent].each do |klass|
        klass.new(self).post
      end
    end

    def recent_events_notice
      [GoogleGroup::RecentEvent, Twitter::RecentEvent, FacebookGroup::RecentEvent].each do |klass|
        klass.new(self).post
      end
    end
  end
end
