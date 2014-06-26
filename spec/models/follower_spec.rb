require 'spec_helper'

describe Follower do
  let(:follower) { FactoryGirl.build :follower }

  context 'building and validation' do
    describe 'standard follower' do
      it 'should build successfully and be valid' do
        expect(follower.valid?).to be_truthy
      end
    end
  end

  context 'public methods' do
  end

  context 'private methods' do
  end
end
