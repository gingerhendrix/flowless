require 'spec_helper'

describe FieldType::EmailType, :type => :model do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:email_type) { FactoryGirl.build :email_type, _type: 'FieldType::EmailType' }

  context 'building and validation on STI' do
    describe 'email_type' do
      it 'should build successfully and be valid' do
        expect(email_type).to be_truthy
      end
    end
  end
end
