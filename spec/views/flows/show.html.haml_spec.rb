require 'rails_helper'

RSpec.describe "flows/show", :type => :view do
  before(:each) do
    @flow = assign(:flow, FactoryGirl.create(:flow))
    @items = @flow.items
  end

  it "renders attributes in <p>" do
    render
  end
end
