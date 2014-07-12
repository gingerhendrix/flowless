require 'rails_helper'

RSpec.describe "items/index", :type => :view do

  let!(:flow)   { FactoryGirl.create :flow }

  before(:each) do
    @flow = flow
    assign(:items, [
      Item.create!(flow_id: flow.id, user_id: flow.user_id, status: flow.valid_statuses.first),
      Item.create!(flow_id: flow.id, user_id: flow.user_id, status: flow.valid_statuses.first)
    ])
  end

  it "renders a list of items" do
    render
  end
end
