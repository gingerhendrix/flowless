require 'spec_helper'

describe "collections/show", :type => :view do
  before(:each) do
    @collection = assign(:collection, stub_model(Collection,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
  end
end
