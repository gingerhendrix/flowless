require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build :user }

  context 'building and validation' do
    describe 'standard user' do
      it 'should build successfully and be valid' do
        expect(user.valid?).to be_true
      end
    end
  end

  context 'public methods' do
    describe 'full_name' do
      let(:user_no_name) { FactoryGirl.build :user_no_name }

      it 'should have a full_name when first_name and last_name are not blank' do
        expect(user.full_name).to eq('John Doe')
      end

      it 'should have an undefined full_name when first_name or last_name are blank' do
        expect(user_no_name.full_name).to eq('undefined')
      end
    end
  end

  context 'private methods' do
  end

end