require 'spec_helper'

shared_context "create_event_with_specific_time" do
  before do
    allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
  end

  let(:datetime) { Time.local(2014, 6, 1, 10, 5) }
  let(:event) do
    Timecop.travel(datetime) { create(:miyohide_san_event) }
  end
end

describe MiyohideSan::Event do
  describe ".recent!" do
    before do
      allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
    end

    context "record exists" do
      let!(:past_event) { create(:miyohide_san_event, {starts_at: Forgery::Date.date(future: false, past: true)}) }
      let!(:future_events) { create(:miyohide_san_event, {starts_at: 7.days.since + 1.hours}) }
      let!(:sent_future_events) { create(:miyohide_san_event, {starts_at: 7.days.since + 2.hours, sent_at: Time.now}) }

      before do
        expect_any_instance_of(MiyohideSan::GoogleGroup::RecentEvent).to receive(:post)
        expect_any_instance_of(MiyohideSan::Twitter::RecentEvent).to receive(:post)
        expect_any_instance_of(MiyohideSan::FacebookGroup::RecentEvent).to receive(:post)
      end

      specify { MiyohideSan::Event.recent! }
    end

    context "no record" do
      let!(:past_event) { create(:miyohide_san_event, {starts_at: Forgery::Date.date(future: false, past: true)}) }

      before do
        expect_any_instance_of(MiyohideSan::GoogleGroup::RecentEvent).not_to receive(:post)
        expect_any_instance_of(MiyohideSan::Twitter::RecentEvent).not_to receive(:post)
        expect_any_instance_of(MiyohideSan::FacebookGroup::RecentEvent).not_to receive(:post)
      end

      specify { MiyohideSan::Event.recent! }
    end
  end

  describe ".fetch!" do
    let(:json) do
      {
        "event" => {
          "title" => "Yokohama.rb Monthly Meetup",
          "public_url" => "http://yokohamarb.doorkeeper.jp/events/1111"
        }
      }
    end

    context "update" do
      before do
        MiyohideSan::Event.create(json["event"])
        expect(MiyohideSan::Doorkeeper::Event).to receive(:latest) { [json] }
        expect_any_instance_of(MiyohideSan::Event).not_to receive(:new_events_notice)
      end

      it { expect { MiyohideSan::Event.fetch! }.not_to change(MiyohideSan::Event, :count) }
    end

    context "create" do
      before do
        expect_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
        expect(MiyohideSan::Doorkeeper::Event).to receive(:latest) { [json] }
      end

      it { expect { MiyohideSan::Event.fetch! }.to change(MiyohideSan::Event, :count).by(1) }
    end

    context "create with false option" do
      before do
        expect(MiyohideSan::Doorkeeper::Event).to receive(:latest) { [json] }
        expect_any_instance_of(MiyohideSan::Event).not_to receive(:new_events_notice)
      end

      it { expect { MiyohideSan::Event.fetch!(false) }.to change(MiyohideSan::Event, :count).by(1) }
    end
  end

  describe ".clean!" do
    before do
      create(:miyohide_san_event, {starts_at: (DateTime.now - 1)})
      create(:miyohide_san_event, {starts_at: (DateTime.now + 1)})
    end

    it { expect { MiyohideSan::Event.clean! }.to change(MiyohideSan::Event, :count).by(-1) }
  end

  describe "#title" do
    before do
      allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
    end

    it { should validate_presence_of(:title) }
  end

  describe "#formatted_starts_at" do
    include_context "create_event_with_specific_time"
    subject { event.formatted_starts_at }
    it { is_expected.to eq "#{datetime.year}年#{"%02d"%datetime.month}月#{"%02d"%datetime.day}日" }
  end

  describe "#start_time" do
    include_context "create_event_with_specific_time"
    subject { event.start_time }
    it { is_expected.to eq "#{"%02d"%datetime.hour}:#{"%02d"%datetime.min}" }
  end

  describe "#end_time" do
    include_context "create_event_with_specific_time"
    subject { event.end_time }
    it { is_expected.to eq "#{"%02d"%datetime.hour}:#{"%02d"%datetime.min}" }
  end

  describe "#weekday" do
    include_context "create_event_with_specific_time"
    subject { event.weekday }
    it { is_expected.to eq "日" }
  end

  describe "#over?" do
    before do
      allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
    end

    subject { event.over? }
    let(:event) { create(:miyohide_san_event, attributes) }

    context "true" do
      let(:attributes) {{ticket_limit: 0, participants: 1}}
      it { is_expected.to be true }
    end

    context "false" do
      let(:attributes) {{ticket_limit: 1, participants: 0}}
      it { is_expected.to be false }
    end
  end

  describe "#recent_events_notice" do
    let(:datetime) { Time.local(2014, 6, 1, 10, 5) }
    let(:event) { create(:miyohide_san_event) }

    before do
      expect_any_instance_of(MiyohideSan::GoogleGroup::RecentEvent).to receive(:post)
      expect_any_instance_of(MiyohideSan::Twitter::RecentEvent).to receive(:post)
      expect_any_instance_of(MiyohideSan::FacebookGroup::RecentEvent).to receive(:post)

      Timecop.travel(datetime) do
        event.recent_events_notice
      end
    end

    it { expect(event.sent_at.strftime("%Y-%m-%d %H:%s")).to eq datetime.strftime("%Y-%m-%d %H:%s") }
  end
end
