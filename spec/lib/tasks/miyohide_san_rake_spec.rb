require 'spec_helper'

describe "fetch" do
  include_context "rake"

  before do
    expect(MiyohideSan::Event).to receive(:fetch!)
  end

  specify { subject.invoke }
end

describe "recent" do
  include_context "rake"

  before do
    expect(MiyohideSan::Event).to receive(:recent!)
  end

  specify { subject.invoke }
end

describe "sync" do
  include_context "rake"

  before do
    expect(MiyohideSan::Event).to receive(:fetch!).with(false)
  end

  specify { subject.invoke }
end

describe "clean" do
  include_context "rake"

  before do
    expect(MiyohideSan::Event).to receive(:clean!)
  end

  specify { subject.invoke }
end

describe "zapier:twitter" do
  include_context "rake"

  before do
    expect_any_instance_of(MiyohideSan::Twitter::NewEvent).to receive(:post)
  end

  specify { subject.invoke }
end

describe "zapier:google_group" do
  include_context "rake"

  before do
    expect_any_instance_of(MiyohideSan::GoogleGroup::NewEvent).to receive(:post)
  end

  specify { subject.invoke }
end

describe "zapier:facebook_group" do
  include_context "rake"

  before do
    expect_any_instance_of(MiyohideSan::FacebookGroup::NewEvent).to receive(:post)
  end

  specify { subject.invoke }
end
