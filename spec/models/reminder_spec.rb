require 'rails_helper'

describe Reminder, :type => :model do
  let(:reminder)  { FactoryGirl.build :reminder }
  let(:recurring) { FactoryGirl.build(:recurring_reminder) }

  context 'building and validation' do
    describe 'standard reminder' do
      it 'should build successfully and be valid' do
        expect(reminder.valid?).to be_truthy
      end
    end

    describe 'validation' do
      it 'should call the custom validation to set the next occurence if reccurring?' do
        expect(reminder).to receive(:calculate_next_occurence)
        allow(reminder).to receive(:recurring?).and_return true
        reminder.valid?
      end
    end
  end

  context 'public methods' do
    let(:time)          { Time.parse('2010-01-01 17:06:17 UTC') }
    let(:another_time)  { Time.parse('2010-01-01 00:00:00 UTC') }

    describe 'calculate_next_occurence' do
      let(:rec)         { double('rec') }

      it 'should call the proper Recurrence method from the gem' do
        expect(Recurrence).to         receive(:new).and_return rec
        allow(rec).to receive(:next).and_return    another_time
        expect(reminder).to           receive(:time_of_day).and_return  17 * 3600 + 6 * 60
        reminder.calculate_next_occurence
        expect(reminder.remind_at.utc).to eq(Time.parse('2010-01-01 17:06:00 UTC'))
      end

      it 'should empty recurrence if an error is encountered' do
        expect(Recurrence).to receive(:new).and_raise Exception.new
        recurring.calculate_next_occurence
        expect(recurring.recurrence).to be_empty
      end
    end

    describe 'time_of_day' do
      it 'should be 0 if there are no remind_at given' do
        allow(reminder).to receive(:remind_at).and_return nil
        expect(reminder.time_of_day).to eq(0)
      end

      it 'should return the proper time of day if remind_at is given' do
        allow(reminder).to receive(:remind_at).and_return time
        expect(reminder.time_of_day).to eq((17 * 3600 + 6 * 60))
      end
    end

    describe 'remind!' do
      it 'should remind users' do
        expect(reminder).to receive(:save!)
        expect(reminder).to receive(:remind_users)
        reminder.remind!
      end

      it 'should mark it as complete if not recurring' do
        reminder.complete = false
        expect(reminder).to receive(:save!)
        reminder.remind!
        expect(reminder.complete).to be_truthy
      end

      it 'should calculate next occurence if recurring' do
        expect(recurring).to receive(:save!)
        expect(recurring).to receive(:calculate_next_occurence)
        recurring.remind!
      end
    end

    describe 'remind_users' do
      # TODO
    end

    describe 'recurring?' do
      it 'should be true' do
        expect(recurring.recurring?).to be_truthy
      end

      it 'should be false' do
        expect(reminder.recurring?).to be_falsey
      end
    end
  end

  context 'private methods' do
  end
end
