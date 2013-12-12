require 'spec_helper'

describe Event do
  let(:event)       { FactoryGirl.build :event }
  let(:read_event)  { FactoryGirl.build :read_event }

  context 'building and validation' do
    describe 'standard event' do
      it 'should build successfully and be valid' do
        expect(event.valid?).to be_true
      end
    end

    describe 'validation' do
      it 'should call set_entity if an entity is present' do
        event.entity = double('entity')
        expect(event).to receive(:set_entity)
        event.valid?
      end
    end
  end

  context 'class methods' do
    describe 'create_multiple_for' do
      let(:user_ids) { [ 1, 2, 3 ] }
      let(:entity)   { double('entity') }
      let(:event1)   { double('event1') }
      let(:event2)   { double('event2') }
      let(:event3)   { double('event3') }

      before :each do
        entity.stub(:id).and_return     42
        entity.stub(:class).and_return  Object
      end

      it 'should create 3 news events when they are all valid' do
        expect(Event).to receive(:new).with(user_id: 1, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event1
        expect(event1).to receive(:save).and_return true
        expect(Event).to receive(:new).with(user_id: 2, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event2
        expect(event2).to receive(:save).and_return true
        expect(Event).to receive(:new).with(user_id: 3, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event3
        expect(event3).to receive(:save).and_return true
        expect(Event.create_multiple_for(user_ids, entity, 'action', { lorem: 'ipsum' })).to be_empty
      end

      it 'should output failed events' do
        expect(Event).to receive(:new).with(user_id: 1, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event1
        expect(event1).to receive(:save).and_return false
        expect(Event).to receive(:new).with(user_id: 2, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event2
        expect(event2).to receive(:save).and_return true
        expect(Event).to receive(:new).with(user_id: 3, entity: entity, action: 'action', data: { lorem: 'ipsum' }).and_return event3
        expect(event3).to receive(:save).and_return false
        expect(Event.create_multiple_for(user_ids, entity, 'action', { lorem: 'ipsum' })).to include(event1, event3)
      end
    end
  end

  context 'public methods' do
    describe 'get_entity' do
      it 'should call find on the proper class' do
        event.stub(:entity_class).and_return  "User"
        event.stub(:entity_id).and_return     69
        expect(User).to receive(:find).with(69)
        event.get_entity
      end
    end

    describe 'set_entity' do
      let(:entity)   { double('entity') }

      before :each do
        entity.stub(:id).and_return     21
        entity.stub(:class).and_return  Hash
      end

      it 'should set id and class from the entity' do
        event.entity_id    = nil
        event.entity_class = nil
        event.entity = entity
        event.set_entity
        expect(event.entity_id).to eq(21)
        expect(event.entity_class).to eq('Hash')
      end
    end

    describe 'mark_as_read!' do
      let(:now) { Time.now.utc }

      it 'should work' do
        read_event.read_at = now - 1.hour
        Time.stub(:now).and_return now
        expect(read_event).to receive(:save!)
        read_event.mark_as_read!
        expect(read_event.read_at).to eq(now)
      end
    end

    describe 'read?' do
      it 'should be true' do
        expect(read_event.read?).to be_true
      end

      it 'should be false' do
        expect(event.read?).to be_false
      end
    end
  end

  context 'private methods' do
  end
end
