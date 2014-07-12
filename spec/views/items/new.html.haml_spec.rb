require 'rails_helper'

RSpec.describe "items/new", :type => :view do

  let!(:flow)   { FactoryGirl.create :flow }

  before(:each) do
    @flow = flow
    assign(:item, Item.new(flow_id: flow.id, user_id: flow.user_id))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", flow_items_path(flow), "post" do
    end
  end
end
