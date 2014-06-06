require 'spec_helper'

describe MiyohideSan::Event do
  it { should validate_numericality_of(:id).is_greater_than(0) }
  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:title) }
end
