require 'spec_helper'

describe MiyohideSan::Yaffle::Announcement do
  let(:event) { create(:miyohide_san_event) }
  let(:announcement) { MiyohideSan::Yaffle::Announcement.new(event) }
  it { expect(announcement.body).to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
end

describe MiyohideSan::Yaffle::PreviousNotice do
  let(:event) { create(:miyohide_san_event) }
  let(:notice) { MiyohideSan::Yaffle::PreviousNotice.new(event) }
  it { expect(notice.body).to match /#{event.formatted_starts_at}|#{event.weekday}|#{event.title}/ }
end
