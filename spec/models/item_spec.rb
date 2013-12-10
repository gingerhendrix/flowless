require 'spec_helper'

describe Item do
  let(:item) { FactoryGirl.build :item }

  before :each do
    item.stub_chain(:flow, :valid_statuses).and_return [ 'my_status' ]
  end

  context 'building and validation' do
    describe 'standard item' do
      it 'should build successfully and be valid' do
        expect(item.valid?).to be_true
      end
    end
  end

  context 'public methods' do
  end

  context 'private methods' do
  end
end
