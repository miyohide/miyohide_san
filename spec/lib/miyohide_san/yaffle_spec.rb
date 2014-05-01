require 'spec_helper'

describe MiyohideSan::Yaffle do
  let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
  subject { MiyohideSan::Yaffle.new(event) }

  describe "#message" do
    it { expect(subject.message).to match /#{event.title}|#{event.date}|#{event.public_url}/ }
  end

  describe "#tweet" do
    before { expect_any_instance_of(Twitter::REST::Client).to receive(:update) }
    it { subject.tweet }
  end
end
