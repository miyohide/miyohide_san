require 'spec_helper'

describe MiyohideSan::FacebookGroup::NewEvent do
  before do
    allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
  end

  let(:event) { create(:miyohide_san_event) }
  let(:message) { MiyohideSan::FacebookGroup::NewEvent.new(event) }

  describe "#body" do
    subject { message.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end

  describe "#url" do
    subject { message.url }
    it { is_expected.to eq "http://localhost:3000/facebook_group" }
  end

  describe "#json" do
    subject { message.json }
    it do
      is_expected.to be_json_as(
        {
          "subject"  => /#{event.title}/,
          "body"  => /#{event.title}|#{event.formatted_starts_at}|#{event.venue_name}/
        }
      )
    end
  end
end

describe MiyohideSan::FacebookGroup::RecentEvent do
  before do
    allow_any_instance_of(MiyohideSan::Event).to receive(:new_events_notice)
  end

  let(:event) { create(:miyohide_san_event) }
  let(:notice) { MiyohideSan::FacebookGroup::RecentEvent.new(event) }

  describe "#body" do
    subject { notice.body }
    it { is_expected.to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
  end
end
