require 'rails_helper'

RSpec.describe "documents/edit", :type => :view, :focus=>true do
  before(:each) do
    @document = assign(:document, (create :document))
  end

  it "renders the edit document form" do
    render

    assert_select "form[action=?][method=?]", document_path(@document), "post" do
    end
  end
end
