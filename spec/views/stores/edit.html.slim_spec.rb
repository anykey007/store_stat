require 'rails_helper'

RSpec.describe "stores/edit", :type => :view, :focus=>true do
  before(:each) do
    @store = create :store
  end

  it "renders the edit store form" do
    render

    assert_select "form[action=?][method=?]", store_path(@store), "post" do

      assert_select "input#store_name[name=?]", "store[name]"
    end
  end
end
