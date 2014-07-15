require 'rails_helper'

RSpec.describe "flows/new", :type => :view do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in user
    assign(:flow, Flow.new())
  end

  it "renders new flow form" do
    render

    assert_select "form[action=?][method=?]", flows_path, "post" do
    end
  end
end
