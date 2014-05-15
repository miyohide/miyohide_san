require 'spec_helper'

describe Doorkeeper::Event do
  describe ".build" do
    subject { Doorkeeper::Event.build(attributes) }

    context "valid" do
      let(:attributes) do
        {
          "id" => Forgery::Basic.number.to_s,
          "starts_at" => Time.now.to_datetime.to_s,
          "ends_at" => Time.now.to_datetime.to_s,
          "updated_at" => Time.now.to_datetime.to_s,
          "published_at" => Time.now.to_datetime.to_s,
          "ticket_limit" => Forgery::Basic.number.to_s,
          "participants" => Forgery::Basic.number.to_s,
          "venue_name" => Forgery::Basic.text
        }
      end

      it { expect(subject.id).to eq attributes["id"].to_i }
      it { expect(subject.starts_at).to eq DateTime.parse(attributes["starts_at"]) }
      it { expect(subject.ticket_limit).to eq attributes["ticket_limit"].to_i }
      it { expect(subject.venue_name).to eq attributes["venue_name"] }
      end

    context "invalid" do
      let(:attributes) do
        {
          "id" => "",
          "starts_at" => "",
          "venue_name" => ""
        }
      end

      it { expect(subject.id).to be_nil }
      it { expect(subject.starts_at).to be_nil }
      it { expect(subject.venue_name).to be_nil }
    end
  end

  describe ".find" do
    subject do
      VCR.use_cassette 'lib/doorkeeper/event' do
        Doorkeeper::Event.find(attributes).first
      end
    end

    let(:attributes) do
      {
        q: "Yokohama.rb Monthly Meetup",
        page: 1,
        locale: "ja",
        sort: "starts_at",
        until: "2014-03-09",
        since: "2014-03-08"
      }
    end

    it { expect(subject.starts_at).to eq DateTime.parse("Sat, 08 Mar 2014 17:00:00 +0900") }
  end
end
