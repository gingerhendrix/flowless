require 'spec_helper'

describe FieldValue::TextMarkupValue do
  let(:item)              { FactoryGirl.build :item }
  let(:field_container)   { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)        { FactoryGirl.build :text_markup_type, _type: 'FieldType::TextMarkupType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:text_markup_value) { FactoryGirl.build :text_markup_value, _type: 'FieldValue::TextMarkupValue', field_container: field_container }

  before :each do
    item.flow.field_types.should_receive(:find).at_least(1).times.and_return field_type
  end

  context 'building and validation on STI' do
    describe 'text_markup_value' do
      it 'should build successfully and be valid' do
        expect(text_markup_value.valid?).to be_true
      end
    end
  end
end