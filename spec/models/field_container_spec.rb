require 'spec_helper'

describe FieldContainer do
  let(:field_container) { FactoryGirl.build :field_container, field_type_id: 'random_field_type_id' }

  context 'building and validation' do
    describe 'standard field_container' do
      it 'should build successfully and be invalid' do
        expect(field_container.valid?).to be_false
      end
    end
  end

  context 'meta programming' do
    describe 'buid_value, new_value, create_value, create_value!' do
      it { field_container.should respond_to :build_value }
      it { field_container.should respond_to :new_value }
      it { field_container.should respond_to :create_value }
      it { field_container.should respond_to :create_value! }
    end

    describe 'checking the detailed behavior of the #created_value! & #build case' do
      before :each do
        field_container.stub(:field_type_to_value).and_return 'FieldValue::TextInputValue'
      end

      it 'should work with just a value' do
        expect(field_container.field_values).to receive(:build).with({ value: 'my_value' }, FieldValue::TextInputValue)
        field_container.build_value('my_value')
      end

      it 'should work with other field also' do
        field_container.field_values.should_receive(:build).with({ value: 'my_value', other_field: 'other_value' }, FieldValue::TextInputValue)
        field_container.build_value('my_value', { other_field: 'other_value' })
      end

      it 'should work with just a value' do
        expect(field_container.field_values).to receive(:create!).with({ value: 'my_value' }, FieldValue::TextInputValue)
        field_container.create_value!('my_value')
      end

      it 'should work with other field also' do
        field_container.field_values.should_receive(:create!).with({ value: 'my_value', other_field: 'other_value' }, FieldValue::TextInputValue)
        field_container.create_value!('my_value', { other_field: 'other_value' })
      end
    end
  end

  context 'public methods' do
    describe 'field_value' do
      let(:field_value_1) { FactoryGirl.build :text_input_value, value: '1', _type: "FieldValue::TextInputValue" }
      let(:field_value_2) { FactoryGirl.build :text_input_value, value: '2', _type: "FieldValue::TextInputValue" }

      before :each do
        field_container.stub_chain(:field_values, :versionned).and_return [ field_value_1, field_value_2 ]
      end

      it 'shoudl return the right field_value' do
        expect(field_container.field_value).to be(field_value_1)
      end
    end

    describe 'value' do
      describe 'no values present' do
        before :each do
          field_container.stub(:field_value).and_return nil
        end

        it 'should not raise an error and return nil' do
          expect(field_container.value).to be(nil)
        end
      end

      describe '2 values are present' do
        let(:field_value) { FactoryGirl.build :text_input_value, value: 'ok', _type: "FieldValue::TextInputValue" }

        before :each do
          field_container.stub(:field_value).and_return field_value
        end

        it 'should return the right value' do
          expect(field_container.value).to eq('ok')
        end
      end
    end

    describe 'field_type' do
      let(:field_type) { OpenStruct.new({ id: 'random_field_type_id' }) }
      let(:collection) { double('field_types') }

      before :each do
        field_container.stub_chain(:item, :flow, :field_types).and_return(collection)
      end

      describe 'not loaded' do
        before :each do
          field_container.instance_variable_set(:@field_type, nil)
        end

        it 'should load the field_type from the db' do
          collection.should_receive(:find).once.with('random_field_type_id')
          field_container.field_type # just calling the method, results does not matter
        end
      end

      describe 'already loaded' do
        before :each do
          field_container.instance_variable_set(:@field_type, field_type)
        end

        it 'should return the already loaded field_type and not perform a db call' do
          collection.should_not_receive(:find)
          expect(field_container.field_type).to eq(field_type)
        end
      end
    end

    describe 'field_type_to_value' do
      before :each do
        field_container.stub_chain(:field_type, :_type).and_return 'FieldType::MySpecialType'
      end

      it 'should convert the _type of field_type to the equivalent field_value _type' do
        expect(field_container.field_type_to_value).to eq('FieldValue::MySpecialValue')
      end
    end
  end

  context 'private methods' do
  end
end