require 'spec_helper'

describe MiyohideSan::Doorkeeper::Event do
  describe "#url" do
    let(:event) { MiyohideSan::Doorkeeper::Event.new }
    subject { event.url.to_s }
    specify { is_expected.to eq "http://api.doorkeeper.jp/groups/yokohamarb/events" }
  end

  describe ".all" do
    subject do
      VCR.use_cassette 'lib/miyohide_san/doorkeeper/events' do
        MiyohideSan::Doorkeeper::Event.all.count
      end
    end

    it { is_expected.to eq 13 }
  end

  describe ".latest" do
    context "Event found" do
      let(:json) {
        Array.new(2) do
          {
            "event" => {
              "title"        => /\AYokohama.rb\sMonthly\sMeetup/,
              "id"           => Fixnum,
              "starts_at"    => /[\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}.[\d]{3}Z/,
              "ends_at"      => /[\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}.[\d]{3}Z/,
              "venue_name"   => "横浜市神奈川地区センター(和室)",
              "address"      => "神奈川県横浜市神奈川区神奈川本町8-1",
              "lat"          => "35.4747236",
              "long"         => "139.63291930000003",
              "ticket_limit" => Fixnum,
              "published_at" => /[\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}.[\d]{3}Z/,
              "updated_at"   => /[\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}.[\d]{3}Z/,
              "description"  => /Yokohama.rbは、横浜周辺のRuby技術者たちが集まってRubyに関する/,
              "public_url"   => /\Ahttp:\/\/yokohamarb\.doorkeeper\.jp\/events\//,
              "participants" => Fixnum,
              "waitlisted"   => Fixnum,
              "group"        => {
                "id"           => Fixnum,
                "name"         => "Yokohama.rb",
                "country_code" => "JP",
                "logo"         => /.+\.jpg$/,
                "description"  => /Yokohama.rbは、横浜周辺のRuby技術者たちが集まってRubyに関する/,
                "public_url"   => "http://yokohamarb.doorkeeper.jp/"
              }
            }
          }
        end
      }

      subject do
        VCR.use_cassette 'lib/miyohide_san/doorkeeper/events' do
          MiyohideSan::Doorkeeper::Event.latest.to_json
        end
      end

      before do
        Time.zone = 'Asia/Tokyo'
        Timecop.freeze(Time.zone.parse("2014-08-04 23:00:00"))
      end

      it { is_expected.to be_json_as(json) }

      after do
        Timecop.return
      end
    end

    context "Event not found" do
      let(:json) { [] }

      subject do
        VCR.use_cassette 'lib/miyohide_san/doorkeeper/events' do
          MiyohideSan::Doorkeeper::Event.latest.to_json
        end
      end

      before do
        Time.zone = 'Asia/Tokyo'
        Timecop.freeze(Time.zone.parse("2015-08-04 23:00:00"))
      end

      it { is_expected.to be_json_as(json) }

      after do
        Timecop.return
      end
    end
  end
end
