require 'spec_helper'

describe MiyohideSan::Event do
  describe ".new" do
    subject { MiyohideSan::Event.new(doorkeeper) }

    let(:doorkeeper) { build(:doorkeeper_event) }
    named_let(:date) { doorkeeper.starts_at.strftime("%Y年%m月%d日") }
    named_let(:starts_at) { (doorkeeper.starts_at + Rational(30, 24 * 60)).strftime("%H:%M") }
    named_let(:open_at) { doorkeeper.starts_at.strftime("%H:%M") }
    named_let(:ends_at) { doorkeeper.ends_at.strftime("%H:%M") }
    named_let(:over) { (doorkeeper.ticket_limit < doorkeeper.participants) }

    it { expect(subject.title).to eq doorkeeper.title }
    it { expect(subject.date).to eq date }
    it { expect(subject.starts_at).to eq starts_at }
    it { expect(subject.open_at).to eq open_at }
    it { expect(subject.ends_at).to eq ends_at }
    it { expect(subject.over?).to eq over }
  end

  describe ".find_by_after_week" do
    let(:attributes) do
      {
        q: "Yokohama.rb Monthly Meetup",
        page: 1,
        locale: "ja",
        sort: "starts_at",
        since: Date.today + 7,
        until: Date.today + 8
      }
    end

    before do
      Timecop.freeze(Time.now)
      expect(Doorkeeper::Event).to receive(:find).with(attributes)
    end

    after do
      Timecop.return
    end

    it { MiyohideSan::Event.find_by_after_week }
  end
end
