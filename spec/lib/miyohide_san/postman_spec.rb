require 'spec_helper'

shared_examples "a email" do
  it { expect(subject).to deliver_to(to) }
  it { expect(subject).to deliver_from(from) }
  it { expect(subject).to have_header("Return-Path", to) }
  it { expect(subject).to have_subject(/#{event.title}/) }
  it { expect(subject).to have_body_text(/#{event.title}|#{event.date}|#{event.venue_name}/) }
  it { expect(subject).to have_subject(text) }
  it { expect(subject).to have_body_text(text) }
end

describe MiyohideSan::Postman do
  let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
  let(:to) { MiyohideSan::Settings.mail.to }
  let(:from) { MiyohideSan::Settings.mail.from }

  describe "#testament" do
    let(:text) { /開催のお知らせ/ }
    subject { MiyohideSan::Postman.testament(event) }
    it_behaves_like "a email"
  end

  describe "#newborn" do
    let(:text) { /募集開始のお知らせ/ }
    subject { MiyohideSan::Postman.newborn(event) }
    it_behaves_like "a email"
  end
end
