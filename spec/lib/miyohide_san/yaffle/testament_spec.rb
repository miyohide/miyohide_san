require 'spec_helper'

describe MiyohideSan::Yaffle::Testament do
  describe "#message" do
    let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
    subject { MiyohideSan::Yaffle::Testament.new(event) }

    it { expect(subject.message).to match(/#{event.title}|#{event.date}|#{event.public_url}/) }
    it { expect(subject.message).to match(/開催します/) }
  end
end
