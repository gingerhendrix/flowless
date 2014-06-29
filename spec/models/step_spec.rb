require 'spec_helper'

describe Step, :type => :model do
  let(:step) { FactoryGirl.build :step }

  context 'building and validation' do
    describe 'standard step' do
      it 'should build successfully and be valid' do
        expect(step).to receive(:single_initial_step)
        expect(step.valid?).to be_truthy
      end
    end

    describe 'validation' do
      it 'single_initial_step' do
        step.errors.clear
        allow(step).to receive_message_chain(:flow, :steps, :initials, :count).and_return 2
        step.single_initial_step
        expect(step.errors.keys).to include(:initial)
      end
    end
  end

  context 'class methods' do
    describe 'initial' do
      let(:step1) { double('step1') }
      let(:step2) { double('step2') }

      it 'should return the initial step' do
        allow(Step).to receive(:initials).and_return [ step1, step2 ]
        expect(Step.initial).to be(step1)
      end
    end
  end

  context 'public methods' do
    let(:flow)  { FactoryGirl.build(:flow) }
    let(:step2) { FactoryGirl.build(:step) }

    before :each do
      allow(step).to receive(:flow).and_return flow
    end

    describe 'incoming_transitions' do
      it 'should call the proper scope with proper parameters' do
        expect(flow.transitions).to receive(:for_source).with(step)
        step.incoming_transitions
      end
    end

    describe 'outgoing_transitions' do
      it 'should call the proper scope with proper parameters' do
        expect(flow.transitions).to receive(:for_destination).with(step)
        step.outgoing_transitions
      end
    end

    describe 'create_transition_to!' do
      it 'should call the create! method with the proper params on transitions' do
        expect(flow.transitions).to receive(:create!).with(source_step: step, destination_step: step2, name: 'lorem', description: 'ipsum')
        step.create_transition_to!(step2, 'lorem', 'ipsum')
      end
    end

    describe 'create_transition_from!' do
      it 'should call the create! method with the proper params on transitions' do
        expect(flow.transitions).to receive(:create!).with(source_step: step2, destination_step: step, name: 'lorem', description: 'ipsum')
        step.create_transition_from!(step2, 'lorem', 'ipsum')
      end
    end
  end

  context 'private methods' do
  end
end
