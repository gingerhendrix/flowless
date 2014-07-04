require 'rails_helper'

describe "collections/new", :type => :view do
  before(:each) do
    assign(:collection, stub_model(Collection,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new collection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", collections_path, "post" do
      assert_select "input#collection_name[name=?]", "collection[name]"
    end
  end
end
