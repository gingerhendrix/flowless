require 'rails_helper'

RSpec.describe "items/edit", :type => :view do

  let!(:flow)   { FactoryGirl.create :flow }

  before(:each) do
    @flow = flow
    @item = assign(:item, Item.create!(flow_id: flow.id, user_id: flow.user_id, status: flow.valid_statuses.first))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", flow_item_path(@flow, @item), "post" do
    end
  end
end
