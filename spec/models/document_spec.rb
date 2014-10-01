require 'rails_helper'

RSpec.describe Document, :type => :model, :focus=>true do
  it { should belong_to(:store) }
  it { should have_many(:rows) }
end
