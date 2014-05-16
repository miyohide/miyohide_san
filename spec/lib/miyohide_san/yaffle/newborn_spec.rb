require 'spec_helper'

describe MiyohideSan::Yaffle::Newborn do
  describe "#message" do
    let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
    subject { MiyohideSan::Yaffle::Newborn.new(event) }

    it { expect(subject.message).to match(/#{event.title}|#{event.date}|#{event.public_url}/) }
    it { expect(subject.message).to match(/募集を開始/) }
  end
end
