require 'rails_helper'

describe FieldValue::InputValue, :type => :model do
  let(:item)             { FactoryGirl.build :item }
  let(:field_container)  { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)       { FactoryGirl.build :input_type, _type: 'FieldType::InputType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:input_value)      { FactoryGirl.build :input_value, _type: 'FieldValue::InputValue', field_container: field_container }

  before :each do
    allow(item.flow.field_types).to receive(:find).at_least(1).times.and_return field_type
  end

  context 'building and validation on STI' do
    describe 'input_value' do
      it 'should build successfully and be valid' do
        expect(input_value.valid?).to be_truthy
      end
    end

    describe 'length_constraints?' do
      it 'should call input_value_length_constraints_validation if there are length_constraints?' do
        expect(input_value).to receive(:length_constraints?).and_return true
        expect(input_value).to receive(:input_value_length_constraints_validation)
        input_value.valid?
      end

      it 'should not call input_value_length_constraints_validation if there are no length_constraints?' do
        expect(input_value).to     receive(:length_constraints?).and_return false
        expect(input_value).to_not receive(:input_value_length_constraints_validation)
        input_value.valid?
      end

      it 'should not call input_value_length_constraints_validation if the value is blank' do
        input_value.value = ' '
        expect(input_value).to     receive(:length_constraints?).and_return true
        expect(input_value).to_not receive(:input_value_length_constraints_validation)
        input_value.valid?
      end
    end

    describe 'validation_regexp' do
      before :each do
        expect(input_value).to receive(:validation_regexp).at_least(1).times.and_return /only_this_regexp/
      end

      it 'should fail if the value does not match the regexp' do
        input_value.value = 'something else than the regexp'
        expect(input_value.valid?).to be_falsey
        expect(input_value.errors[:value]).to_not be_empty
      end

      it 'should be ok if the value match the regepx' do
        input_value.value = 'only_this_regexp'
        expect(input_value.valid?).to be_truthy
        expect(input_value.errors[:value]).to be_empty
      end

      it 'should be ok if the value is blank but optional is allowed' do
        input_value.value = ' '
        expect(input_value).to receive(:optional?).and_return true
        expect(input_value.valid?).to be_truthy
        expect(input_value.errors[:value]).to be_empty
      end

      it 'should not allow blank if optional is false' do
        input_value.value = ' '
        expect(input_value).to receive(:optional?).and_return false
        expect(input_value.valid?).to be_falsey
        expect(input_value.errors[:value]).to_not be_empty
      end
    end
  end

  context 'public methods' do
    describe 'input_value_length_constraints_validation' do
      before :each do
        allow(input_value).to receive(:length_constraints?).at_least(1).times.and_return true
      end

      it 'should raise value validation errors if the value is not within the constraints of min_char_count and max_char_count' do
        input_value.value = '123456789'

        allow(input_value).to receive(:min_char_count).times.and_return 0
        allow(input_value).to receive(:max_char_count).times.and_return 100
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to be_empty

        input_value.errors.clear

        allow(input_value).to receive(:min_char_count).times.and_return 10
        allow(input_value).to receive(:max_char_count).times.and_return 100
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to_not be_empty

        input_value.errors.clear

        allow(input_value).to receive(:min_char_count).times.and_return 9
        allow(input_value).to receive(:max_char_count).times.and_return 9
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to be_empty

        input_value.errors.clear

        allow(input_value).to receive(:min_char_count).times.and_return nil
        allow(input_value).to receive(:max_char_count).times.and_return 8
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to_not be_empty

        input_value.errors.clear

        allow(input_value).to receive(:min_char_count).times.and_return 10
        allow(input_value).to receive(:max_char_count).times.and_return nil
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to_not be_empty

        input_value.errors.clear

        allow(input_value).to receive(:min_char_count).times.and_return 5
        allow(input_value).to receive(:max_char_count).times.and_return nil
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to be_empty

        input_value.errors.clear

        allow(input_value).to receive(:min_char_count).times.and_return nil
        allow(input_value).to receive(:max_char_count).times.and_return 10
        expect(input_value.input_value_length_constraints_validation).to_not eq false
        expect(input_value.errors[:value]).to be_empty
      end
    end
  end
end