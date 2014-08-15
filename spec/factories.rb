# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :miyohide_san_event, class: 'MiyohideSan::Event' do
    id { Forgery::Basic.number }
    title { Forgery::Basic.text }
    starts_at { Time.now.to_datetime }
    ends_at { Time.now.to_datetime }
    venue_name { Forgery::Basic.text }
    address { Forgery::Basic.text }
    ticket_limit { Forgery::Basic.number }
    published_at { Time.now.to_datetime }
    updated_at { Time.now.to_datetime }
    description { Forgery::Basic.text }
    public_url { "http://#{Forgery(:internet).domain_name}" }
    participants { Forgery::Basic.number }
    waitlisted { Forgery::Basic.number }
    lat "35.4747236"
    long "139.63291930000003"
    sent_at nil
  end
end
