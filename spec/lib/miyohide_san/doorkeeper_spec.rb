require 'spec_helper'

describe MiyohideSan::Doorkeeper::Base do
  describe "#url" do
    let(:event) { MiyohideSan::Doorkeeper::Base.new }

    context "paramsが定義済みの場合" do
      let(:host) { Forgery::Internet.domain_name }
      let(:path) { "/#{Forgery::Basic.text(allow_lower: true, allow_upper: false, allow_special: false)}" }

      before do
        allow(event).to receive(:params) do
          {
            host: host,
            path: path
          }
        end
      end

      subject { event.url }
      specify { expect(subject.path).to eq path }
      specify { expect(subject.host).to eq host }
    end

    context "paramsが未定義の場合" do
      it { expect{ event.url }.to raise_error(StandardError) }
    end
  end
end

describe MiyohideSan::Doorkeeper do
  describe ".recent" do
    before do
      Time.zone = 'Asia/Tokyo'
      Timecop.freeze(Time.zone.parse("2014-05-03 15:00:00"))
    end

    subject do
      MiyohideSan::Doorkeeper.recent
    end

    it "JSON format であること" do
      VCR.use_cassette 'lib/miyohide_san/doorkeeper/event' do
        expect(subject.to_json).to be_json_as(
          {
              "title"        => "Yokohama.rb Monthly Meetup #44",
               "id"           => 9780,
               "starts_at"    => "2014-05-10T08:00:00.000Z",
               "ends_at"      => "2014-05-10T12:00:00.000Z",
               "venue_name"   => "横浜市神奈川地区センター(和室)",
               "address"      => "神奈川県横浜市神奈川区神奈川本町8-1",
               "lat"          => "35.4747236",
               "long"         => "139.63291930000003",
               "ticket_limit" => 25,
               "published_at" => "2014-03-12T09:28:30.904Z",
               "updated_at"   => "2014-05-27T07:43:09.245Z",
               "description"  => /\A<p>Yokohama.rbは、横浜周辺のRuby技術者たちが/,
               "public_url"   => "http://yokohamarb.doorkeeper.jp/events/9780",
               "participants" => 20,
               "waitlisted"   => 0,
               "group"        => {
                 "id"           => 351,
                 "name"         => "Yokohama.rb",
                 "country_code" => "JP",
                 "logo"         => /351_normal_1379068089_418962_283018831765118_2146366848_n.jpg\z/,
                 "description"  => /\A<p>Yokohama.rbは、横浜周辺のRuby技術者たちが/,
                 "public_url"   => "http://yokohamarb.doorkeeper.jp/"
               }
            }
        )
      end
    end

    after do
      Timecop.return
    end
  end

  describe ".last" do
    subject do
      MiyohideSan::Doorkeeper.last
    end

    xit "JSON format であること" do
      VCR.use_cassette 'lib/miyohide_san/doorkeeper/group' do
        expect(subject.to_json).to be_json_as(
          "event" => {
            "title"        => "Yokohama.rb Monthly Meetup #46",
            "id"           => 11377,
            "starts_at"    => "2014-07-12T08:30:00.000Z",
            "ends_at"      => "2014-07-12T12:00:00.000Z",
            "venue_name"   => "横浜市神奈川地区センター(和室)",
            "address"      => "神奈川県横浜市神奈川区神奈川本町8-1",
            "lat"          => "35.4747236",
            "long"         => "139.63291930000003",
            "ticket_limit" => 25,
            "published_at" => "2014-05-10T08:45:40.935Z",
            "updated_at"   => "2014-05-27T07:43:54.048Z",
            "description"  => /\A<p>Yokohama.rbは、横浜周辺のRuby技術者たちが集まってRubyに関する/,
            "public_url"   => "http://yokohamarb.doorkeeper.jp/events/11377",
            "participants" => 4,
            "waitlisted"   => 0,
            "group"        => {
              "id"           => 351,
              "name"         => "Yokohama.rb",
              "country_code" => "JP",
              "logo"         => /351_normal_1379068089_418962_283018831765118_2146366848_n.jpg/,
              "description"  => /\A<p>Yokohama.rbは、横浜周辺のRuby技術者たちが集まってRubyに関する/,
              "public_url"   => "http://yokohamarb.doorkeeper.jp/"
            }
          }
        )
      end
    end
  end
end
