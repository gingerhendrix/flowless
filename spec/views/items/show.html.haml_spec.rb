require 'rails_helper'

RSpec.describe "items/show", :type => :view do

  let!(:flow)   { FactoryGirl.create :flow }

  before(:each) do
    @flow = flow
    @item = assign(:item, Item.create!(flow_id: flow.id, user_id: flow.user_id, status: flow.valid_statuses.first))
  end

  it "renders attributes in <p>" do
    render
  end
end
