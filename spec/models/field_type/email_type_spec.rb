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

    describe 'multiple_emails' do
      it 'should not allow nil for that field' do
        email_type.multiple_emails = nil
        expect(email_type.valid?).to be_falsey
        expect(email_type.errors[:multiple_emails]).to_not be_empty
      end
    end
  end

  context 'public methods' do
  end
end
