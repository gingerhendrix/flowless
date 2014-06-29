require 'spec_helper'

describe "collections/index", :type => :view do
  before(:each) do
    assign(:collections, Kaminari.paginate_array([
      stub_model(Collection,
        :name => "Name"
      ),
      stub_model(Collection,
        :name => "Name"
      )
    ]).page)
  end

  it "renders a list of collections" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
