module MiyohideSan
  class Event
    include Mongoid::Document

    field :id, type: Integer
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

    validates :id, presence: true, numericality: { greater_than: 0 }
    validates :title, presence: true

    def self.last
      Event.order_by(:starts_at.desc).first
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

    def previous_notice
      Yaffle::PreviousNotice.new(self).tap do |yaffle|
        yaffle.post
      end

      Postman::PreviousNotice.new(self).tap do |postman|
        postman.post
      end
    end
  end
end
