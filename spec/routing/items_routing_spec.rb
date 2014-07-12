require "rails_helper"

RSpec.describe ItemsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/flows/1/items").to route_to("items#index", flow_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/flows/1/items/new").to route_to("items#new", flow_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/flows/1/items/1").to route_to("items#show", id: '1', flow_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/flows/1/items/1/edit").to route_to("items#edit", id: '1', flow_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/flows/1/items").to route_to("items#create", flow_id: '1')
    end

    it "routes to #update" do
      expect(:put => "/flows/1/items/1").to route_to("items#update", id: '1', flow_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/flows/1/items/1").to route_to("items#destroy", id: '1', flow_id: '1')
    end

  end
end
