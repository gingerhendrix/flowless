require 'spec_helper'

describe Transition do
  let(:transition) { FactoryGirl.build :transition }

  context 'building and validation' do
    describe 'standard transition' do
      it 'should build successfully and be valid' do
        expect(transition.valid?).to be_true
      end
    end

    describe 'accessors' do
      let(:step) { OpenStruct.new(id: 13) }
      let(:flow) { FactoryGirl.build(:flow) }

      before :each do
        transition.stub(:flow).and_return flow
      end

      describe 'source_step' do
        it 'should set the source_step_id form the attr_accessor' do
          transition.source_step_id = nil
          transition.source_step    = step
          expect(transition.source_step_id).to eq(13)
        end

        it 'should find the right source step' do
          transition.source_step_id = 35
          expect(flow.steps).to receive(:find).with(35)
          transition.source_step
        end
      end

      describe 'destination_step' do
        it 'should set the destination_step_id form the attr_accessor' do
          transition.destination_step_id = nil
          transition.destination_step    = step
          expect(transition.destination_step_id).to eq(13)
        end

        it 'should find the right source step' do
          transition.destination_step_id = 54
          expect(flow.steps).to receive(:find).with(54)
          transition.destination_step
        end
      end
    end
  end

  context 'public methods' do
    describe 'source_step and destination_status' do
      let(:source_step)       { OpenStruct.new(name: 'source_step') }
      let(:destination_step)  { OpenStruct.new(name: 'destination_step') }

      before :each do
        transition.stub(:source_step).and_return source_step
        transition.stub(:destination_step).and_return destination_step
      end

      it 'should call the name of the source_step' do
        expect(transition.source_status).to eq('source_step')
      end

      it 'should call the name of the destination_step' do
        expect(transition.destination_status).to eq('destination_step')
      end
    end
  end

  context 'private methods' do
  end
end
