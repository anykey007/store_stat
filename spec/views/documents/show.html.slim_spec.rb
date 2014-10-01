require 'rails_helper'

RSpec.describe "documents/show", :type => :view, :focus=>true do
  before(:each) do
    @document = assign(:document, (create :document))
  end

  it "renders attributes in <p>" do
    render
  end
end
