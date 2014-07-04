require 'rails_helper'

describe FieldType::InputType, :type => :model do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:input_type) { FactoryGirl.build :input_type, _type: 'FieldType::InputType' }

  context 'building and validation on STI' do
    describe 'input_type' do
      it 'should build successfully and be valid' do
        expect(input_type.valid?).to be_truthy
      end
    end

    describe 'validation_regexp' do
      it 'should always be a regexp' do
        input_type.validation_regexp = "some string"
        expect(input_type.validation_regexp).to eq /some string/
      end
    end

    describe 'masked' do
      it 'should always validate presence' do
        input_type.masked = nil
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:masked]).to_not be_empty
      end
    end

    describe 'min_char_count' do
      it 'should only take integer greater or equal than 0 or be nil' do
        input_type.min_char_count = -1
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:min_char_count]).to_not be_empty

        input_type.min_char_count = 23.3
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:min_char_count]).to_not be_empty

        input_type.min_char_count = 0
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:min_char_count]).to be_empty

        input_type.min_char_count = 10
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:min_char_count]).to be_empty

        input_type.min_char_count = nil
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:min_char_count]).to be_empty
      end
    end

    describe 'max_char_count' do
      it 'should only take integer greater or equal than 1 or be nil' do
        input_type.min_char_count = nil
        input_type.max_char_count = -1
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:max_char_count]).to_not be_empty

        input_type.max_char_count = 23.3
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:max_char_count]).to_not be_empty

        input_type.max_char_count = 0
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:max_char_count]).to_not be_empty

        input_type.max_char_count = 1
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:max_char_count]).to be_empty

        input_type.max_char_count = 10
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:max_char_count]).to be_empty

        input_type.max_char_count = nil
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:max_char_count]).to be_empty
      end

      it 'should also be greater or equal than minimum_max_char_count_allowed' do
        expect(input_type).to receive(:minimum_max_char_count_allowed).at_least(1).times.and_return 10

        input_type.max_char_count = 0
        expect(input_type.valid?).to be_falsey
        expect(input_type.errors[:max_char_count]).to_not be_empty

        input_type.max_char_count = 10
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:max_char_count]).to be_empty

        input_type.max_char_count = 100
        expect(input_type.valid?).to be_truthy
        expect(input_type.errors[:max_char_count]).to be_empty
      end
    end
  end

  context 'public methods' do
    describe 'length_constraints?' do
      it 'should be true if there is a max_char_count constraint' do
        input_type.min_char_count = nil
        input_type.max_char_count = 10
        expect(input_type.length_constraints?).to be_truthy
      end

      it 'should be true if there is a min_char_count constraint' do
        input_type.min_char_count = 0
        input_type.max_char_count = nil
        expect(input_type.length_constraints?).to be_truthy
      end

      it 'should be false if there are no constraints' do
        input_type.min_char_count = nil
        input_type.max_char_count = nil
        expect(input_type.length_constraints?).to be_falsey
      end
    end

    describe 'minimum_max_char_count_allowed' do
      it 'should never less than 1 even if min_char_count is equal to 0' do
        input_type.min_char_count = 0
        expect(input_type.minimum_max_char_count_allowed).to eq 1
      end

      it 'should return 1 if there are not min_char_count defined' do
        input_type.min_char_count = nil
        expect(input_type.minimum_max_char_count_allowed).to eq 1
      end

      it 'should return the same value as min_char_count as long as its greather than 0' do
        input_type.min_char_count = 1
        expect(input_type.minimum_max_char_count_allowed).to eq 1

        input_type.min_char_count = 10
        expect(input_type.minimum_max_char_count_allowed).to eq 10
      end
    end
  end
end
