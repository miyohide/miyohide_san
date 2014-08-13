require 'spec_helper'

shared_context "create_event_with_specific_time" do
  before do
    allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
  end

  let(:datetime) { [2014, 6, 1, 10, 5] }
  let(:event) do
    Timecop.travel(*datetime) { create(:miyohide_san_event) }
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

  describe "#title" do
    before do
      allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
    end

    it { should validate_presence_of(:title) }
  end

  describe "#formatted_starts_at" do
    include_context "create_event_with_specific_time"
    subject { event.formatted_starts_at }
    it { is_expected.to eq "#{datetime[0]}年#{"%02d"%[datetime[1]]}月#{"%02d"%[datetime[2]]}日" }
  end

  describe "#start_time" do
    include_context "create_event_with_specific_time"
    subject { event.start_time }
    it { is_expected.to eq "#{"%02d"%[datetime[3]]}:#{"%02d"%[datetime[4]]}" }
  end

  describe "#end_time" do
    include_context "create_event_with_specific_time"
    subject { event.end_time }
    it { is_expected.to eq "#{"%02d"%[datetime[3]]}:#{"%02d"%[datetime[4]]}" }
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
end
