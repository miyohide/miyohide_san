require 'spec_helper'

describe MiyohideSan::Yaffle::Base do
  let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
  subject { MiyohideSan::Yaffle::Base.new(event) }

  describe "#tweet" do
    before do
      expect_any_instance_of(Twitter::REST::Client).to receive(:update).with(text)
      expect(subject).to receive(:message) { text }
    end
    let(:text) { Forgery::Basic.text }
    it { subject.tweet }
  end

  describe "#message" do
    it { expect{ subject.message }.to raise_error(StandardError, "Messaget undefined.") }
  end
end
