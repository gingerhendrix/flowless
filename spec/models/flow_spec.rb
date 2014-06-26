require 'spec_helper'

describe Flow do
  let(:flow) { FactoryGirl.build :flow }

  context 'building and validation' do
    describe 'standard flow' do
      it 'should build successfully and be valid' do
        expect(flow.valid?).to be_truthy
      end
    end
  end

  context 'public methods' do
    describe 'valid_statuses' do
      before :each do
        flow.stub(:steps).and_return [ OpenStruct.new(name: 'name1'), OpenStruct.new(name: 'name2') ]
      end

      it 'return the valid status list' do
        expect(flow.valid_statuses).to eq([ 'name1', 'name2' ])
      end
    end
  end

  context 'private methods' do
  end
end