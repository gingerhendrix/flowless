require 'spec_helper'

describe Item do
  let(:item) { FactoryGirl.build :item }

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
