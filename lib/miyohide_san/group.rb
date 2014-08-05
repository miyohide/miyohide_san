module MiyohideSan
  class Group
    include Mongoid::Document

    field :name, type: String
    field :country_code, type: String
    field :logo, type: String
    field :description, type: String
    field :public_url, type: String

    embedded_in :event, inverse_of: :event
  end
end
