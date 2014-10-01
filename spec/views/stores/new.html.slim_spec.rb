require 'rails_helper'

RSpec.describe "stores/new", :type => :view, :focus=>true do
  before(:each) do
    assign(:store, Store.new(
      :name => "MyString"
    ))
  end

  it "renders new store form" do
    render

    assert_select "form[action=?][method=?]", stores_path, "post" do

      assert_select "input#store_name[name=?]", "store[name]"
    end
  end
end
