class Doorkeeper::Event < OpenStruct
  attr_reader :group

  def initialize(event = {})
    @group = Doorkeeper::Group.new(event.delete("group"))
    super(event)
  end

  def self.build(event)
    result = event.inject({}) do |h, (k, v)|
      if v.blank?
        h[k] = nil
        next h
      end

      case k
      when "starts_at", "ends_at", "updated_at", "published_at"
          h[k] = DateTime.parse(v).new_offset("+0900").to_time
      when "ticket_limit", "participants", "id"
        h[k] = v.to_i
      else
        h[k] = v
      end

      h
    end

    self.new(result)
  end

  def self.find(conditions = {})
    query = conditions.map{|key, val| "#{key}=#{URI.encode(val.to_s)}"}

    response = Net::HTTP.start("api.doorkeeper.jp") do |http|
      http.get("/events?#{query.join("&")}")
    end

    JSON.parse(response.body).map{|event| self.build(event["event"])}
  end
end
