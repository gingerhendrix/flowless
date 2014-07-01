require 'spec_helper'

# stub_chain #allow(field_value).to receive_message_chain(:field_type, :optional).and_return true

describe FieldValue, :type => :model do
  let(:item)            { FactoryGirl.build :item }
  let(:field_container) { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:input_type)      { FactoryGirl.build :input_type, _type: 'FieldType::InputType' }

  context 'building and validation on STI' do
    describe 'base field_value' do
      let(:field_value)     { FactoryGirl.build :field_value, field_container: field_container }

      before :each do
        expect(item.flow.field_types).to receive(:find).at_least(1).times.and_return input_type
      end

      it 'should build successfully and be invalid' do
        expect(field_value.valid?).to be_falsey
      end
    end

    describe '_type of field_value is different from the _type of the linked field_type' do
      let(:textarea_value)     { FactoryGirl.build :textarea_value, _type: 'FieldValue::TextareaValue', field_container: field_container }

      before :each do
        expect(item.flow.field_types).to receive(:find).at_least(1).times.and_return input_type
      end

      it 'should be invalid' do
        expect(textarea_value.valid?).to be_falsey
      end
    end

    describe '_type of field_value is the same as the _type of the linked field_type' do
      let(:input_value)     { FactoryGirl.build :input_value, _type: 'FieldValue::InputValue', field_container: field_container }

      before :each do
        expect(item.flow.field_types).to receive(:find).at_least(1).times.and_return input_type
      end

      it 'should be valid' do
        expect(input_value.valid?).to be_truthy
      end
    end

    describe 'value validation of unicity if the associated field_type requires it' do
      let(:field_value)     { FactoryGirl.build :field_value, field_container: field_container , _type: 'FieldValue::TestValue' }
      let(:field_type)      { FactoryGirl.build :field_type, _type: 'FieldType::TestType' }

      before :each do
        allow(field_container).to receive(:field_type).and_return field_type
      end

      it 'should trigger the unicity validation if the associated field_type requires it' do
        field_type.uniq = true
        expect(field_value).to receive :value_special_uniqueness_validation
        field_value.valid?
      end

      it 'should be invalid to have an empty value if the associated field_type does not have an optional presence' do
        field_type.uniq = false
        expect(field_value).to_not receive :value_special_uniqueness_validation
        field_value.valid?
      end
    end

    describe 'value validation of presence if the associated field_type requires it' do
      let(:field_value)     { FactoryGirl.build :field_value, field_container: field_container , _type: 'FieldValue::TestValue' }
      let(:field_type)      { FactoryGirl.build :field_type, _type: 'FieldType::TestType' }

      before :each do
        allow(field_container).to receive(:field_type).and_return field_type
      end

      it 'should be valid to have an empty value if the associated field_type has an optional presence' do
        field_type.optional = true
        expect(field_value.valid?).to be_truthy
      end

      it 'should be invalid to have an empty value if the associated field_type does not have an optional presence' do
        expect(field_value).to receive(:value).twice.and_return nil
        field_type.optional = false
        expect(field_value.valid?).to be_falsey
      end

      it 'should be valid to have a value if the associated field_type does not have an optional presence' do
        expect(field_value).to receive(:value).and_return 'some_value'
        field_type.optional = false
        expect(field_value.valid?).to be_truthy
      end

      it 'should be valid to have a value if the associated field_type does have an optional presence, it should not even check the value' do
        expect(field_value).not_to receive(:value)
        field_type.optional = true
        expect(field_value.valid?).to be_truthy
      end
    end
  end

  context 'managing the default value' do
    let(:field_value)     { FactoryGirl.build :field_value, field_container: field_container }

    describe 'set_default_value callback' do
      it 'should call the set_default_value method upon building the field_value' do
        expect_any_instance_of(FieldValue).to receive(:set_default_value)
        field_container.field_values.new
      end
    end

    describe 'set_default_value' do
      it 'should not set the default value if there is an existing value' do
        expect(field_value).to receive(:value).twice.and_return 'my_value'
        expect(field_value).to_not receive(:value=)
        field_value.set_default_value
        expect(field_value.value).to eq 'my_value'
      end

      it 'should not set the default value if there are no default value even tough value is nil' do
        expect(field_value).to receive(:value).and_return nil
        expect(field_value).to receive(:default_value).once.and_return nil
        expect(field_value).to_not receive(:value=)
        field_value.set_default_value
      end

      it 'should only set the default value if current value is nil' do
        expect(field_value).to receive(:default_value).twice.and_return 'my_default_value'
        expect(field_value).to receive(:value).once.and_return nil
        expect(field_value).to receive(:value=).with('my_default_value')
        field_value.set_default_value
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
