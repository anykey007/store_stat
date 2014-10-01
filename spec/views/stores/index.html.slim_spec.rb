require 'rails_helper'

RSpec.describe "stores/index", :type => :view, :focus=>true do
  before(:each) do
    assign(:stores, (create_list :store, 2, name: 'Name'))
  end

  it "renders a list of stores" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
