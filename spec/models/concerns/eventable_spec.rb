require 'spec_helper'

describe Eventable, :type => :model do
  let (:user)       { FactoryGirl.build(:user) }
  let (:test_class) { Struct.new(:user) { include Eventable } }
  let (:entity)     { test_class.new(user) }


  context 'meta programming' do
    let(:fake_user) { double('user') }
    describe '#new_event #build_event #create_event #create_event!' do
      it { expect(entity).to respond_to :new_event }
      it { expect(entity).to respond_to :build_event }
      it { expect(entity).to respond_to :create_event }
      it { expect(entity).to respond_to :create_event! }

      it 'checking the detailed behavior of the #build_event' do
        expect(user.events).to receive(:build).with(entity: entity, action: 'action', data: { lorem: 'ipsum'} )
        entity.build_event(user, 'action', { lorem: 'ipsum'} )
      end
    end
  end

  context 'class methods' do
    describe 'create_multiple_for' do
      let(:user_ids) { [ 1, 2, 3 ] }
      let(:event1)   { double('event1') }
      let(:event2)   { double('event2') }
      let(:event3)   { double('event3') }

      it 'should create 3 news events when they are all valid' do
        expect(Event).to receive(:new).with(user_id: 1, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event1
        expect(event1).to receive(:save).and_return true
        expect(Event).to receive(:new).with(user_id: 2, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event2
        expect(event2).to receive(:save).and_return true
        expect(Event).to receive(:new).with(user_id: 3, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event3
        expect(event3).to receive(:save).and_return true
        expect(entity.create_multiple_events_for(user_ids, 'action', { lorem: 'ipsum' })).to be_empty
      end

      it 'should output failed events' do
        expect(Event).to receive(:new).with(user_id: 1, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event1
        expect(event1).to receive(:save).and_return false
        expect(Event).to receive(:new).with(user_id: 2, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event2
        expect(event2).to receive(:save).and_return true
        expect(Event).to receive(:new).with(user_id: 3, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event3
        expect(event3).to receive(:save).and_return false
        expect(entity.create_multiple_events_for(user_ids, 'action', { lorem: 'ipsum' })).to include(event1, event3)
      end
    end
  end
end