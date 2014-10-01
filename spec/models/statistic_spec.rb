require 'rails_helper'

RSpec.describe Statistic, :type => :model, :focus=>true do
  it { should belong_to(:store) }
end
