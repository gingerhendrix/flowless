require 'rails_helper'

describe Item, :type => :model do
  let(:item) { FactoryGirl.build :item, status: 'my_status' }

  before :each do
    allow(item).to receive_message_chain(:flow, :valid_statuses).and_return [ 'my_status', 'valid_status' ]
  end

  context 'building and validation' do
    describe 'standard item' do
      it 'should build successfully and be valid' do
        expect(item.valid?).to be_truthy
      end
    end

    describe 'validation', :pending do
      it 'status inclusion' do
        item.errors.clear
        item.status = 'no_among_the_list'
        expect(item.valid?).to be_falsey
        expect(item.errors.keys).to include(:status)
      end
    end
  end

  context 'public methods' do
    let(:flow) { FactoryGirl.build :flow }

    before :each do
      allow(item).to receive(:flow).and_return flow
    end

    describe 'step' do
      let(:step1)       { double('step1') }
      let(:step2)       { double('step2') }

      it 'should return the correct step' do
        expect(item.flow.steps).to receive(:with_status).with('my_status').and_return [ step1, step2 ]
        expect(item.step).to be(step1)
      end
    end

    describe 'incoming_transitions' do
      it 'should call the proper scope with the right params' do
        expect(item.flow.transitions).to receive(:for_source).with(item)
        item.incoming_transitions
      end
    end

    describe 'outgoing_transitions' do
      it 'should call the proper scope with the right params' do
        expect(item.flow.transitions).to receive(:for_destination).with(item)
        item.outgoing_transitions
      end
    end

    describe 'apply_transition!' do
      let(:transition)  { FactoryGirl.build(:transition) }

      before :each do
        allow(transition).to receive(:destination_status).and_return 'something'
        allow(transition).to receive(:flow).and_return OpenStruct.new(id: 42)
      end

      it 'should call set_status if the transition can be applied' do
        expect(item).to receive(:can_apply_transition?).with(transition).and_return true
        expect(item).to receive(:set_status!).with('something')
        item.apply_transition!(transition)
      end

      it 'should raise the appropriate error if the transition cannot be applied' do
        expect(item).to     receive(:can_apply_transition?).with(transition).and_return false
        expect(item).to_not receive(:set_status!)
        expect{ item.apply_transition!(transition) }.to raise_error Exceptions::InapplicableTransition
      end
    end

    describe 'current_field_values' do
      let(:criteria)      { double('criteria') }
      let(:container1)    { FactoryGirl.build :field_container, item: item }
      let(:container2)    { FactoryGirl.build :field_container, item: item }
      let(:container3)    { FactoryGirl.build :field_container, item: item, field_type_id: 42 }
      let!(:value1fromC1) { FactoryGirl.build :input_value, value: 'value1fromC1', current: false, field_container: container1 }
      let!(:value2fromC1) { FactoryGirl.build :input_value, value: 'value2fromC1', current: false, field_container: container1 }
      let!(:value3fromC1) { FactoryGirl.build :input_value, value: 'value3fromC1', current: true,  field_container: container1 }
      let!(:value1fromC2) { FactoryGirl.build :input_value, value: 'value1fromC2', current: false, field_container: container2 }
      let!(:value1fromC3) { FactoryGirl.build :input_value, value: 'value1fromC3', current: true,  field_container: container3 }

      it 'should pass field_values options down to the containers' do
        expect(container1).to receive(:current_field_value).with(foo: :bar)
        expect(container3).to receive(:current_field_value).with(foo: :bar)

        item.current_field_values({ field_value: { foo: :bar } })
      end

      it 'should handle field_container options with scope and its name when no params are passed' do
        expect(FieldContainer).to receive(:my_scope).with(no_args).at_least(3).times.and_return(FieldContainer.criteria)

        item.current_field_values(field_container: { scope: { name: :my_scope, params: nil } })
        item.current_field_values(field_container: { scope: { name: :my_scope, params: [] } })
        item.current_field_values(field_container: { scope: { name: :my_scope } })
      end

      it 'should handle field_container options with scope and its name and params (one or many)' do
        expect(FieldContainer).to receive(:my_scope).twice.with(:my_params).and_return(FieldContainer.criteria)
        item.current_field_values(field_container: { scope: { name: :my_scope, params: :my_params } })
        item.current_field_values(field_container: { scope: { name: :my_scope, params: [:my_params] } })

        expect(FieldContainer).to receive(:my_scope).with(:p1, :p2).and_return(FieldContainer.criteria)
        item.current_field_values(field_container: { scope: { name: :my_scope, params: [:p1, :p2] } })
      end

      it 'should handle field_container options with selector' do
        expect(FieldContainer).to receive(:with_current_values).and_return(criteria) # have to stub this one to prevent usage of the with_current_values scope to trigget the expect below
        expect(criteria).to receive(:where).with(:my_selector).and_return(FieldContainer.criteria)

        item.current_field_values(field_container: { selector: :my_selector })
      end

      it 'should returns only the values that are current' do
        values = item.current_field_values

        expect(values).to     include value3fromC1
        expect(values).to     include value1fromC3
        expect(values).not_to include value2fromC1
        expect(values).not_to include value1fromC1
        expect(values).not_to include value1fromC2
        expect(values).not_to include nil
      end

      it 'should ignore wrong options' do
        values = item.current_field_values({ foo: :bar })

        expect(values).to     include value3fromC1
        expect(values).to     include value1fromC3
        expect(values).not_to include value2fromC1
        expect(values).not_to include value1fromC1
        expect(values).not_to include value1fromC2
        expect(values).not_to include nil
      end

      it 'should work on some live cases based on the factory values with selector and scope' do
        values = item.current_field_values(field_container: { selector: { field_type_id: 42 } })
        expect(values).to match_array [ value1fromC3 ]

        values = item.current_field_values(field_container: { scope: { name: :with_field_type, params: 42 } })
        expect(values).to match_array [ value1fromC3 ]
      end
    end

    describe 'current_field_values_with_field_type_id' do
      let!(:field_container1) { FactoryGirl.build :field_container, item: item, field_type_id: 'my_field_type_id' }
      let!(:value1)           { FactoryGirl.build :field_value, field_container: field_container1, current: true }
      let!(:value3)           { FactoryGirl.build :field_value, field_container: field_container1, current: false }

      let!(:field_container2) { FactoryGirl.build :field_container, item: item, field_type_id: 'some_other_field_type_id' }
      let!(:value2)           { FactoryGirl.build :field_value, field_container: field_container2, current: true }

      it 'should call the proper scope with params on the current field values' do
        expect(FieldContainer).to receive(:with_field_type).once.with('my_field_type_id').and_call_original
        item.current_field_values_with_field_type_id('my_field_type_id')
      end
    end
  end

  context 'private methods' do
    describe 'can_apply_transition?' do
      let(:good_flow)   { double('good_flow') }
      let(:wrong_flow)  { double('wrong_flow') }
      let(:good_t)      { OpenStruct.new(source_status: 'good_status',  flow: good_flow) }
      let(:wrong_t1)    { OpenStruct.new(source_status: 'wrong_status', flow: good_flow) }
      let(:wrong_t2)    { OpenStruct.new(source_status: 'good_status',  flow: wrong_flow) }

      before :each do
        allow(item).to receive(:status).and_return 'good_status'
        allow(item).to receive(:flow).and_return good_flow
      end

      it 'should be false when status are different' do
        expect(item.send :can_apply_transition?, wrong_t1).to be_falsey
      end

      it 'should be false when flow are different' do
        expect(item.send :can_apply_transition?, wrong_t2).to be_falsey
      end

      it 'otherwise it should be true' do
        expect(item.send :can_apply_transition?, good_t).to be_truthy
      end
    end

    describe 'set_status!' do
      it 'should work' do
        expect(item).to receive(:save!)
        item.status = 'toto'
        item.send :set_status!, 'tata'
        expect(item.status).to eq 'tata'
      end
    end
  end
end
