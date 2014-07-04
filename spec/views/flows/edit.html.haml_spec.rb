require 'rails_helper'

RSpec.describe "flows/edit", :type => :view do

  before(:each) do
    @flow = assign(:flow, FactoryGirl.create(:flow))
  end

  it "renders the edit flow form" do
    render

    assert_select "form[action=?][method=?]", flow_path(@flow), "post" do
    end
  end
end
