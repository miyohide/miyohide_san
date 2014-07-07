require 'spec_helper'

describe MiyohideSan::Yaffle::Announcement do
  let(:event) { create(:miyohide_san_event) }
  let(:announcement) { MiyohideSan::Yaffle::Announcement.new(event) }

  describe "#body" do
    subject { announcement.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end

  describe "#url" do
    let(:url) { "http://twitter.com/" }
    let(:zaiper) { double("zaiper") }

    before do
      expect(zaiper).to receive(:twitter) { url }
      expect(MiyohideSan::Settings).to receive(:zapier) { zaiper }
    end

    subject { announcement.url }
    it { is_expected.to eq url }
  end

  describe "#json" do
    subject { announcement.json }
    it { expect(subject).to be_json_as({"body"  => /#{event.title}/}) }
  end
end

describe MiyohideSan::Yaffle::PreviousNotice do
  let(:event) { create(:miyohide_san_event) }
  let(:notice) { MiyohideSan::Yaffle::PreviousNotice.new(event) }

  describe "#body" do
    subject { notice.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end
end
