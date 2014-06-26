require 'spec_helper'

describe FieldValue::EmailValue do
  let(:item)              { FactoryGirl.build :item }
  let(:field_container)   { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)        { FactoryGirl.build :email_type, _type: 'FieldType::EmailType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:email_value)       { FactoryGirl.build :email_value, _type: 'FieldValue::EmailValue', field_container: field_container }

  before :each do
    item.flow.field_types.should_receive(:find).at_least(1).times.and_return field_type
  end

  context 'building and validation on STI' do
    describe 'email_value' do
      it 'should build successfully and be valid' do
        expect(email_value.valid?).to be_truthy
      end
    end
  end
end