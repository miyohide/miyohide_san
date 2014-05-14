require 'spec_helper'

describe MiyohideSan::LastEvent do
  let(:doorkeeper) { build(:doorkeeper_event, {id: 1}) }
  let(:event) { MiyohideSan::Event.new(doorkeeper) }
  subject { MiyohideSan::LastEvent.new }

  before do
    ActiveSupport::Cache::FileStore.new(MiyohideSan::LastEvent::CACHE_DIR).clear
  end

  it { expect(subject).to eq event }
  it { expect((subject > event)).to be_false }
  it { expect((subject < event)).to be_false }
  it { expect((subject >= event)).to be_true }
  it { expect((subject <= event)).to be_true }
end
