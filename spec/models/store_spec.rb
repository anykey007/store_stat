require 'rails_helper'

RSpec.describe Store, :type => :model, :focus=>true do
  it { should have_many(:documents) }
  it { should have_many(:rows) }
  it { should have_many(:statistics) }
end
