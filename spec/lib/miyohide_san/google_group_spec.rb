require 'spec_helper'

describe MiyohideSan::GoogleGroup::NewEvent do
  before do
    allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
  end

  let(:event) { create(:miyohide_san_event) }
  let(:message) { MiyohideSan::GoogleGroup::NewEvent.new(event) }

  describe "#body" do
    subject { message.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end

  describe "#url" do
    subject { message.url }
    it { is_expected.to eq "http://localhost:3000/google_group" }
  end

  describe "#json" do
    subject { message.json }
    it do
      is_expected.to be_json_as(
        {
          "body"  => /#{event.title}|#{event.formatted_starts_at}|#{event.venue_name}/,
          "subject"  => /#{event.title}/
        }
      )
    end
  end
end

describe MiyohideSan::GoogleGroup::RecentEvent do
  before do
    allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
  end

  let(:event) { create(:miyohide_san_event) }
  let(:notice) { MiyohideSan::GoogleGroup::RecentEvent.new(event) }

  describe "#body" do
    subject { notice.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end

  describe "#subject" do
    subject { notice.subject }
    it { is_expected.to match /#{event.title}/ }
  end
end
