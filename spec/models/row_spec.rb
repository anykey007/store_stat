require 'rails_helper'

RSpec.describe Row, :type => :model, :focus=>true do
  it { should belong_to(:document) }
end
