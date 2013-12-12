require 'spec_helper'

describe Item do
  let(:item) { FactoryGirl.build :item, status: 'my_status' }

  before :each do
    item.stub_chain(:flow, :valid_statuses).and_return [ 'my_status', 'valid_status' ]
  end

  context 'building and validation' do
    describe 'standard item' do
      it 'should build successfully and be valid' do
        expect(item.valid?).to be_true
      end
    end

    describe 'validation' do
      it 'status inclusion' do
        item.errors.clear
        item.status = 'no_among_the_list'
        expect(item.valid?).to be_false
        expect(item.errors.keys).to include(:status)
      end
    end
  end

  context 'public methods' do
    let(:flow) { FactoryGirl.build :flow }

    before :each do
      item.stub(:flow).and_return flow
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
        transition.stub(:destination_status).and_return 'something'
        transition.stub(:flow).and_return OpenStruct.new(id: 42)
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
  end

  context 'private methods' do
    describe 'can_apply_transition?' do
      let(:good_flow)   { double('good_flow') }
      let(:wrong_flow)  { double('wrong_flow') }
      let(:good_t)      { OpenStruct.new(source_status: 'good_status',  flow: good_flow) }
      let(:wrong_t1)    { OpenStruct.new(source_status: 'wrong_status', flow: good_flow) }
      let(:wrong_t2)    { OpenStruct.new(source_status: 'good_status',  flow: wrong_flow) }

      before :each do
        item.stub(:status).and_return 'good_status'
        item.stub(:flow).and_return good_flow
      end

      it 'should be false when status are different' do
        expect(item.send :can_apply_transition?, wrong_t1).to be_false
      end

      it 'should be false when flow are different' do
        expect(item.send :can_apply_transition?, wrong_t2).to be_false
      end

      it 'otherwise it should be true' do
        expect(item.send :can_apply_transition?, good_t).to be_true
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
