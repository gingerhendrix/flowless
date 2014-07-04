require "rails_helper"

RSpec.describe FlowsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/flows").to route_to("flows#index")
    end

    it "routes to #new" do
      expect(:get => "/flows/new").to route_to("flows#new")
    end

    it "routes to #show" do
      expect(:get => "/flows/1").to route_to("flows#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/flows/1/edit").to route_to("flows#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/flows").to route_to("flows#create")
    end

    it "routes to #update" do
      expect(:put => "/flows/1").to route_to("flows#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/flows/1").to route_to("flows#destroy", :id => "1")
    end

  end
end
