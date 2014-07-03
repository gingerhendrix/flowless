require 'spec_helper'

describe FieldValue::TextareaValue, :type => :model do
  let(:item)            { FactoryGirl.build :item }
  let(:field_container) { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)      { FactoryGirl.build :textarea_type, _type: 'FieldType::TextareaType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:textarea_value)  { FactoryGirl.build :textarea_value, _type: 'FieldValue::TextareaValue', field_container: field_container }

  before :each do
    allow(item.flow.field_types).to receive(:find).at_least(1).times.and_return field_type
  end

  context 'building and validation on STI' do
    describe 'textarea_value' do
      it 'should build successfully and be valid' do
        expect(textarea_value.valid?).to be_truthy
      end
    end

    describe 'length_constraints?' do
      it 'should call textarea_value_length_constraints_validation if there are length_constraints?' do
        expect(textarea_value).to receive(:length_constraints?).and_return true
        expect(textarea_value).to receive(:textarea_value_length_constraints_validation)
        textarea_value.valid?
      end

      it 'should not call textarea_value_length_constraints_validation if there are no length_constraints?' do
        expect(textarea_value).to     receive(:length_constraints?).and_return false
        expect(textarea_value).to_not receive(:textarea_value_length_constraints_validation)
        textarea_value.valid?
      end

      it 'should not call textarea_value_length_constraints_validation if the value is blank' do
        textarea_value.value = ' '
        expect(textarea_value).to     receive(:length_constraints?).and_return true
        expect(textarea_value).to_not receive(:textarea_value_length_constraints_validation)
        textarea_value.valid?
      end
    end

    describe 'validation_regexp' do
      before :each do
        expect(textarea_value).to receive(:validation_regexp).at_least(1).times.and_return /only_this_regexp/
      end

      it 'should fail if the value does not match the regexp' do
        textarea_value.value = 'something else than the regexp'
        expect(textarea_value.valid?).to be_falsey
        expect(textarea_value.errors[:value]).to_not be_empty
      end

      it 'should be ok if the value match the regepx' do
        textarea_value.value = 'only_this_regexp'
        expect(textarea_value.valid?).to be_truthy
        expect(textarea_value.errors[:value]).to be_empty
      end

      it 'should be ok if the value is blank but optional is allowed' do
        textarea_value.value = ' '
        expect(textarea_value).to receive(:optional?).and_return true
        expect(textarea_value.valid?).to be_truthy
        expect(textarea_value.errors[:value]).to be_empty
      end

      it 'should not allow blank if optional is false' do
        textarea_value.value = ' '
        expect(textarea_value).to receive(:optional?).and_return false
        expect(textarea_value.valid?).to be_falsey
        expect(textarea_value.errors[:value]).to_not be_empty
      end
    end
  end

  context 'public methods' do
    describe 'textarea_value_length_constraints_validation' do
      before :each do
        allow(textarea_value).to receive(:length_constraints?).at_least(1).times.and_return true
      end

      it 'should raise value validation errors if the value is not within the constraints of min_char_count and max_char_count' do
        textarea_value.value = '123456789'

        allow(textarea_value).to receive(:min_char_count).times.and_return 0
        allow(textarea_value).to receive(:max_char_count).times.and_return 100
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to be_empty

        textarea_value.errors.clear

        allow(textarea_value).to receive(:min_char_count).times.and_return 10
        allow(textarea_value).to receive(:max_char_count).times.and_return 100
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to_not be_empty

        textarea_value.errors.clear

        allow(textarea_value).to receive(:min_char_count).times.and_return 9
        allow(textarea_value).to receive(:max_char_count).times.and_return 9
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to be_empty

        textarea_value.errors.clear

        allow(textarea_value).to receive(:min_char_count).times.and_return nil
        allow(textarea_value).to receive(:max_char_count).times.and_return 8
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to_not be_empty

        textarea_value.errors.clear

        allow(textarea_value).to receive(:min_char_count).times.and_return 10
        allow(textarea_value).to receive(:max_char_count).times.and_return nil
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to_not be_empty

        textarea_value.errors.clear

        allow(textarea_value).to receive(:min_char_count).times.and_return 5
        allow(textarea_value).to receive(:max_char_count).times.and_return nil
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to be_empty

        textarea_value.errors.clear

        allow(textarea_value).to receive(:min_char_count).times.and_return nil
        allow(textarea_value).to receive(:max_char_count).times.and_return 10
        expect(textarea_value.textarea_value_length_constraints_validation).to_not eq false
        expect(textarea_value.errors[:value]).to be_empty
      end
    end
  end
end
