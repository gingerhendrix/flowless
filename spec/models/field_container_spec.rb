require 'rails_helper'

describe FieldContainer, :type => :model do
  let(:field_container) { FactoryGirl.build :field_container, field_type_id: 'random_field_type_id' }

  context 'building and validation' do
    describe 'standard field_container' do
      it 'should build successfully and be invalid' do
        expect(field_container.valid?).to be_falsey
      end

      it 'should be valid with the correct information' do
        field_container.item = Item.new
        expect(field_container.valid?).to be_truthy
      end
    end
  end

  context 'meta programming' do
    describe 'buid_value, new_value, create_value, create_value!' do
      it { expect(field_container).to respond_to :build_value }
      it { expect(field_container).to respond_to :new_value }
      it { expect(field_container).to respond_to :create_value }
      it { expect(field_container).to respond_to :create_value! }
    end

    describe 'checking the detailed behavior of the #created_value! & #build case' do
      before :each do
        allow(field_container).to receive(:field_type_to_value).and_return 'FieldValue::InputValue'
      end

      it 'should work with just a value' do
        expect(field_container.field_values).to receive(:build).with({ value: 'my_value' }, FieldValue::InputValue)
        field_container.build_value('my_value')
      end

      it 'should work with other field also' do
        expect(field_container.field_values).to receive(:build).with({ value: 'my_value', other_field: 'other_value' }, FieldValue::InputValue)
        field_container.build_value('my_value', { other_field: 'other_value' })
      end

      it 'should work with just a value' do
        expect(field_container.field_values).to receive(:create!).with({ value: 'my_value' }, FieldValue::InputValue)
        field_container.create_value!('my_value')
      end

      it 'should work with other field also' do
        expect(field_container.field_values).to receive(:create!).with({ value: 'my_value', other_field: 'other_value' }, FieldValue::InputValue)
        field_container.create_value!('my_value', { other_field: 'other_value' })
      end
    end
  end

  context 'public methods' do
    describe 'field_value' do
      let(:field_value_1) { FactoryGirl.build :input_value, value: '1', _type: "FieldValue::InputValue", current: true }
      let(:field_value_2) { FactoryGirl.build :input_value, value: '2', _type: "FieldValue::InputValue" }

      before :each do
        allow(field_container).to receive(:current_values).and_return [ field_value_1, field_value_2 ]
      end

      it 'should return the right field_value' do
        expect(field_container.field_value).to be(field_value_1)
      end
    end

    describe 'current_value' do
      let(:field_value) { FactoryGirl.build :input_value, value: 'test' }

      before :each do
        allow(field_container).to receive(:current_field_value).and_return field_value
      end

      it 'should return the value of the field_value' do
        expect(field_container.current_value).to eq('test')
      end
    end

    describe 'current_values' do
      let!(:field_value_1) { FactoryGirl.build :input_value, value: '1', _type: "FieldValue::InputValue", field_container: field_container, current: true }
      let!(:field_value_2) { FactoryGirl.build :input_value, value: '2', _type: "FieldValue::InputValue", field_container: field_container, current: false }
      let!(:field_value_3) { FactoryGirl.build :input_value, value: '3', _type: "FieldValue::InputValue", field_container: field_container, current: false }

      it 'should only return the field_values that are current' do
        expect(FieldValue).to receive(:current).and_call_original
        values = field_container.current_values
        expect(values).to     include field_value_1
        expect(values).to_not include field_value_2
        expect(values).to_not include field_value_3
      end
    end

    describe 'current_field_value' do
      let(:criteria)       { double('criteria') }
      let!(:field_value_1) { FactoryGirl.build :input_value, value: '1', _type: "FieldValue::InputValue", field_container: field_container, current: true }
      let!(:field_value_2) { FactoryGirl.build :input_value, value: '2', _type: "FieldValue::InputValue", field_container: field_container, current: true }
      let!(:field_value_3) { FactoryGirl.build :input_value, value: '3', _type: "FieldValue::InputValue", field_container: field_container, current: false }

      it 'should return the first current value if no parameters are passed' do
        expect(field_container.current_field_value).to be field_value_2
      end

      it 'should ignore wrong options' do
        expect(field_container.current_field_value({ foo: :bar })).to be field_value_2
      end

      it 'should options with scope and its name when no params are passed' do
        expect(FieldValue).to receive(:my_scope).with(no_args).at_least(3).times.and_return(FieldValue.criteria)

        field_container.current_field_value({ scope: { name: :my_scope, params: nil } })
        field_container.current_field_value({ scope: { name: :my_scope, params: [] } })
        field_container.current_field_value({ scope: { name: :my_scope } })
      end

      it 'should handle options with scope and its name and params (one or many)' do
        expect(FieldValue).to receive(:my_scope).twice.with(:my_params).and_return(FieldValue.criteria)
        field_container.current_field_value({ scope: { name: :my_scope, params: :my_params } })
        field_container.current_field_value({ scope: { name: :my_scope, params: [:my_params] } })

        expect(FieldValue).to receive(:my_scope).with(:p1, :p2).and_return(FieldValue.criteria)
        field_container.current_field_value({ scope: { name: :my_scope, params: [:p1, :p2] } })
      end

      it 'should handle options with selector' do
        expect(FieldValue).to receive(:current).and_return(criteria) # have to stub this one to prevent usage of the current scope to trigget the expect below
        expect(criteria).to receive(:where).with(:my_selector).and_return(FieldValue.criteria)

        field_container.current_field_value({ selector: :my_selector })
      end

      it 'should work on some live cases based on the factory values with selector and scope' do
        value = field_container.current_field_value(selector: { value: '2' })
        expect(value).to be field_value_2

        value = field_container.current_field_value(scope: { name: :with_value, params: '2' })
        expect(value).to be field_value_2
      end

    end

    describe 'field_type' do
      let(:field_type) { OpenStruct.new({ id: 'random_field_type_id' }) }
      let(:collection) { double('field_types') }

      before :each do
        allow(field_container).to receive_message_chain(:item, :flow, :field_types).and_return(collection)
      end

      describe 'not loaded' do
        before :each do
          field_container.instance_variable_set(:@field_type, nil)
        end

        it 'should load the field_type from the db' do
          expect(collection).to receive(:find).once.with('random_field_type_id')
          field_container.field_type # just calling the method, results does not matter
        end
      end

      describe 'already loaded' do
        before :each do
          field_container.instance_variable_set(:@field_type, field_type)
        end

        it 'should return the already loaded field_type and not perform a db call' do
          expect(collection).not_to receive(:find)
          expect(field_container.field_type).to eq(field_type)
        end
      end
    end

    describe 'field_type_to_value' do
      before :each do
        allow(field_container).to receive_message_chain(:field_type, :_type).and_return 'FieldType::MySpecialType'
      end

      it 'should convert the _type of field_type to the equivalent field_value _type' do
        expect(field_container.field_type_to_value).to eq('FieldValue::MySpecialValue')
      end
    end
  end

  context 'private methods' do
  end
end