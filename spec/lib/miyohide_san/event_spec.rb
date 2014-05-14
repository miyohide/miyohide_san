require 'spec_helper'

shared_context 'cache exist' do
  let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
  let(:doorkeeper) { build(:doorkeeper_event, id: event_id) }
  subject { MiyohideSan::Event.new(doorkeeper) }

  before do
    ActiveSupport::Cache::FileStore.new(MiyohideSan::LastEvent::CACHE_DIR).tap do |cache|
      cache.clear
      cache.write('event', event)
    end
  end
end

describe MiyohideSan::Event do
  describe ".new" do
    subject { MiyohideSan::Event.new(doorkeeper) }

    let(:doorkeeper) { build(:doorkeeper_event) }
    named_let(:date) { doorkeeper.starts_at.strftime("%Y年%m月%d日") }
    named_let(:starts_at) { doorkeeper.starts_at.strftime("%H:%M") }
    named_let(:ends_at) { doorkeeper.ends_at.strftime("%H:%M") }
    named_let(:over) { (doorkeeper.ticket_limit < doorkeeper.participants) }

    it { expect(subject.title).to eq doorkeeper.title }
    it { expect(subject.date).to eq date }
    it { expect(subject.starts_at).to eq starts_at }
    it { expect(subject.ends_at).to eq ends_at }
    it { expect(subject.over?).to eq over }
  end

  describe ".find_by_one_week_later" do
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

    it { MiyohideSan::Event.find_by_one_week_later }
  end

  describe ".last" do
    let(:attributes) do
      {
        q: "Yokohama.rb Monthly Meetup",
        page: 1,
        locale: "ja",
        sort: "starts_at"
      }
    end

    before do
      Timecop.freeze(Time.now)
      expect(Doorkeeper::Event).to receive(:find).with(attributes) { [] }
    end

    after do
      Timecop.return
    end

    it { MiyohideSan::Event.last }
  end

  describe "#new_record?" do
    context "first" do
      let(:doorkeeper) { build(:doorkeeper_event) }
      subject { MiyohideSan::Event.new(doorkeeper) }

      before do
        ActiveSupport::Cache::FileStore.new(MiyohideSan::LastEvent::CACHE_DIR).clear
      end

      it { expect(subject.new_record?).to be_false }
    end

    context "new" do
      include_context 'cache exist'
      let(:event_id) { event.id + 1 }
      it { expect(subject.new_record?).to be_true }
    end

    context "same" do
      include_context 'cache exist'
      let(:event_id) { event.id }
      it { expect(subject.new_record?).to be_false }
    end

    context "old" do
      include_context 'cache exist'
      let(:event_id) { event.id - 1 }
      it { expect(subject.new_record?).to be_false }
    end
  end
end
