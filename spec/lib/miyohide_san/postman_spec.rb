require 'spec_helper'

describe MiyohideSan::Postman::Announcement do
  let(:event) { create(:miyohide_san_event) }
  let(:announcement) { MiyohideSan::Postman::Announcement.new(event) }
  # it { expect(announcement.body).to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }

  describe "#body" do
    subject { announcement.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end

  describe "#url" do
    let(:url) { "http://www.google.com/" }
    let(:zaiper) { double("zaiper") }

    before do
      expect(zaiper).to receive(:mail) { url }
      expect(MiyohideSan::Settings).to receive(:zapier) { zaiper }
    end

    subject { announcement.url }
    it { is_expected.to eq url }
  end

  describe "#json" do
    let(:to) { Forgery::Email.address }
    let(:from) { Forgery::Email.address }
    let(:mail) { double("mail") }

    before do
      expect(mail).to receive(:to) { to }
      expect(mail).to receive(:from) { from }
      expect(MiyohideSan::Settings).to receive(:mail) { mail }.twice
    end

    subject { announcement.json }
    it { is_expected.to be_json_as(
      {
        "body"  => /#{event.title}|#{event.formatted_starts_at}|#{event.venue_name}/,
        "subject"  => /#{event.title}/,
        "from"  => from,
        "to"  => to
      }
      )
    }
  end
end

describe MiyohideSan::Postman::PreviousNotice do
  let(:event) { create(:miyohide_san_event) }
  let(:notice) { MiyohideSan::Postman::PreviousNotice.new(event) }
  it { expect(notice.body).to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
end
