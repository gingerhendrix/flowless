require 'spec_helper'

describe FieldValue do
  let(:item)            { FactoryGirl.build :item }
  let(:field_container) { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:input_type)      { FactoryGirl.build :input_type, _type: 'FieldType::InputType' }

  context 'building and validation on STI' do
    describe 'base field_value' do
      let(:field_value)     { FactoryGirl.build :field_value, field_container: field_container }

      before :each do
        item.flow.field_types.should_receive(:find).at_least(1).times.and_return input_type
      end

      it 'should build successfully and be invalid' do
        expect(field_value.valid?).to be_falsey
      end
    end

    describe '_type of field_value is different from the _type of the linked field_type' do
      let(:textarea_value)     { FactoryGirl.build :textarea_value, _type: 'FieldValue::TextareaValue', field_container: field_container }

      before :each do
        item.flow.field_types.should_receive(:find).at_least(1).times.and_return input_type
      end

      it 'should be invalid' do
        expect(textarea_value.valid?).to be_falsey
      end
    end

    describe '_type of field_value is the same as the _type of the linked field_type' do
      let(:input_value)     { FactoryGirl.build :input_value, _type: 'FieldValue::InputValue', field_container: field_container }

      before :each do
        item.flow.field_types.should_receive(:find).at_least(1).times.and_return input_type
      end

      it 'should be valid' do
        expect(input_value.valid?).to be_truthy
      end
    end
  end

  context 'scopes' do
    describe 'versionned' do
      it 'should have the proper criteria sort option' do
        expect(field_container.field_values.versionned.options[:sort]).to eq({ '_id' => -1 })
      end
    end
  end

end
