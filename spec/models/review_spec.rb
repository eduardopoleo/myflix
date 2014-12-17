require 'spec_helper'
describe Review do
  it {should belong_to(:video)}
  it {should validate_presence_of(:content)}
  it {should validate_presence_of(:rating)}
end
