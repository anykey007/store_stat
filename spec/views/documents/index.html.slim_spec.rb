require 'rails_helper'

RSpec.describe "documents/index", :type => :view, :focus=>true do
  before(:each) do
    assign(:documents, (create_list :document, 2))
  end

  it "renders a list of documents" do
    render
  end
end
