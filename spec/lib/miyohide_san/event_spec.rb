require 'spec_helper'

shared_context "create_event_with_specific_time" do
  let(:datetime) { [2014, 6, 1, 10, 5] }
  let(:event) do
    Timecop.travel(*datetime) { create(:miyohide_san_event) }
  end
end

describe MiyohideSan::Event do
  it { should validate_numericality_of(:id).is_greater_than(0) }
  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:title) }

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

  describe "#previous_notice" do
    before do
      expect(yaffle).to receive(:post)
      expect(postman).to receive(:post)
      expect(MiyohideSan::Yaffle::PreviousNotice).to receive(:new).with(event) { yaffle }
      expect(MiyohideSan::Postman::PreviousNotice).to receive(:new).with(event) { postman }
    end

    let(:event) { build(:miyohide_san_event) }
    let(:yaffle) { instance_double("Yaffle", post: true) }
    let(:postman) { instance_double("Postman", post: true) }

    specify { event.previous_notice }
  end
end
