require 'spec_helper'

describe User do
  it {should have_many(:queue_items).order(:order)}
end
