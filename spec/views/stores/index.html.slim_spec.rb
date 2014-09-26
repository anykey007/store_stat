require 'rails_helper'

RSpec.describe "stores/index", :type => :view do
  before(:each) do
    assign(:stores, [
      Store.create!(
        :name => "Name"
      ),
      Store.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of stores" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
