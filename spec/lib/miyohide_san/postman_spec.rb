require 'spec_helper'

describe MiyohideSan::Postman::Announcement do
  let(:event) { create(:miyohide_san_event) }
  let(:announcement) { MiyohideSan::Postman::Announcement.new(event) }
  it { expect(announcement.body).to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
end

describe MiyohideSan::Postman::PreviousNotice do
  let(:event) { create(:miyohide_san_event) }
  let(:notice) { MiyohideSan::Postman::PreviousNotice.new(event) }
  it { expect(notice.body).to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
end
