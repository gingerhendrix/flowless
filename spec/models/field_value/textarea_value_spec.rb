require 'spec_helper'

describe FieldValue::TextareaValue, :type => :model do
  let(:item)            { FactoryGirl.build :item }
  let(:field_container) { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)      { FactoryGirl.build :textarea_type, _type: 'FieldType::TextareaType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:textarea_value)  { FactoryGirl.build :textarea_value, _type: 'FieldValue::TextareaValue', field_container: field_container }

  before :each do
    expect(item.flow.field_types).to receive(:find).at_least(1).times.and_return field_type
  end

  context 'building and validation on STI' do
    describe 'textarea_value' do
      it 'should build successfully and be valid' do
        expect(textarea_value.valid?).to be_truthy
      end
    end
  end
end
