require 'rails_helper'

RSpec.describe "Items", :type => :request do

  let!(:flow)   { FactoryGirl.create :flow }
  let!(:status) { flow.valid_statuses.first }
  let!(:item)   { FactoryGirl.create :item, flow_id: flow.id, status: status }

  describe "GET /items" do
    it "works! (now write some real specs)" do
      get flow_items_path(flow)
      expect(response.status).to be(302) # because of dirty redirect to display the items within the parent flow
    end
  end
end
