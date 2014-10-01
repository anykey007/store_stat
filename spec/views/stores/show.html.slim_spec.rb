require 'rails_helper'

RSpec.describe "stores/show", :type => :view, :focus=>true do
  before(:each) do
    @store = assign(:store, Store.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
