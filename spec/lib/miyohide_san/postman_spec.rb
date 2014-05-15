require 'spec_helper'

describe MiyohideSan::Postman do
  subject { MiyohideSan::Postman.notify(event) }
  let(:event) { MiyohideSan::Event.new(build(:doorkeeper_event)) }
  let(:to) { MiyohideSan::Settings.mail.to }
  let(:from) { MiyohideSan::Settings.mail.from }

  it { expect(subject).to deliver_to(to) }
  it { expect(subject).to deliver_from(from) }
  it { expect(subject).to have_header("Return-Path", to) }
  it { expect(subject).to have_subject(/#{event.title}/) }
  it { expect(subject).to have_body_text(/#{event.title}|#{event.date}|#{event.venue_name}/) }
end
