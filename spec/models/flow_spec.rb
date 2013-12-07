require 'spec_helper'

describe Flow do
  let(:flow) { FactoryGirl.build :flow }

  context 'building and validation' do
    describe 'standard flow' do
      it 'should build successfully and be valid' do
        expect(flow.valid?).to be_true
      end
    end
  end

  context 'public methods' do
  end

  context 'private methods' do
  end
end