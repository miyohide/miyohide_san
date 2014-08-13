module MiyohideSan
  class DummyEvent < OpenStruct
    def initialize
      super({
         title: "Yokohama.rb Monthly Meetup #48",
         venue_name: "横浜市神奈川地区センター(和室)",
         public_url: "http://yokohamarb.doorkeeper.jp/events/13359",
         formatted_starts_at: "2014年09月13日",
         start_time: "17:00",
         end_time: "21:00",
         over?: true,
         weekday: "土"
        })
    end
  end
end
