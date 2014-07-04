require 'rails_helper'

RSpec.describe "flows/index", :type => :view do

  before(:each) do
    assign(:flows, [
      FactoryGirl.create(:flow),
      FactoryGirl.create(:flow)
    ])
  end

  it "renders a list of flows" do
    render
  end
end
