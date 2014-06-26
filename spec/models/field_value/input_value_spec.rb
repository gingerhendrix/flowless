require 'spec_helper'

describe FieldValue::InputValue do
  let(:item)             { FactoryGirl.build :item }
  let(:field_container)  { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)       { FactoryGirl.build :input_type, _type: 'FieldType::InputType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:input_value)      { FactoryGirl.build :input_value, _type: 'FieldValue::InputValue', field_container: field_container }

  before :each do
    item.flow.field_types.should_receive(:find).at_least(1).times.and_return field_type
  end

  context 'building and validation on STI' do
    describe 'input_value' do
      it 'should build successfully and be valid' do
        expect(input_value.valid?).to be_truthy
      end
    end
  end
end