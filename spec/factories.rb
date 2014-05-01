# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :doorkeeper_event, class: 'Doorkeeper::Event' do
    id { Forgery::Basic.number }
    title { Forgery::Basic.text }
    starts_at { Time.now.to_datetime }
    ends_at { Time.now.to_datetime }
    ticket_limit { Forgery::Basic.number }
    participants { Forgery::Basic.number }
    public_url { "http://#{Forgery(:internet).domain_name}" }
    venue_name {  Forgery::Basic.text }
  end
end
