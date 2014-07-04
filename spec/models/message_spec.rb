require 'rails_helper'

describe Message, :type => :model do
  let(:message) { FactoryGirl.build :message }

  context 'building and validation' do
    describe 'standard message' do
      it 'should build successfully and be valid' do
        expect(message.valid?).to be_truthy
      end
    end
  end

  context 'public methods' do
  end

  context 'private methods' do
  end
end