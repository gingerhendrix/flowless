require 'spec_helper'

describe FieldType::TextareaType, :type => :model do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:textarea_type) { FactoryGirl.build :textarea_type, _type: 'FieldType::TextareaType' }

  context 'building and validation on STI' do
    describe 'textarea_type' do
      it 'should build successfully and be valid' do
        expect(textarea_type.valid?).to be_truthy
      end
    end

    describe 'validation_regexp' do
      it 'should always be a regexp' do
        textarea_type.validation_regexp = "some string"
        expect(textarea_type.validation_regexp).to eq /some string/
      end
    end

    describe 'min_char_count' do
      it 'should only take integer greater or equal than 0 or be nil' do
        textarea_type.min_char_count = -1
        expect(textarea_type.valid?).to be_falsey
        expect(textarea_type.errors[:min_char_count]).to_not be_empty

        textarea_type.min_char_count = 23.3
        expect(textarea_type.valid?).to be_falsey
        expect(textarea_type.errors[:min_char_count]).to_not be_empty

        textarea_type.min_char_count = 0
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:min_char_count]).to be_empty

        textarea_type.min_char_count = 10
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:min_char_count]).to be_empty

        textarea_type.min_char_count = nil
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:min_char_count]).to be_empty
      end
    end

    describe 'max_char_count' do
      it 'should only take integer greater or equal than 1 or be nil' do
        textarea_type.min_char_count = nil
        textarea_type.max_char_count = -1
        expect(textarea_type.valid?).to be_falsey
        expect(textarea_type.errors[:max_char_count]).to_not be_empty

        textarea_type.max_char_count = 23.3
        expect(textarea_type.valid?).to be_falsey
        expect(textarea_type.errors[:max_char_count]).to_not be_empty

        textarea_type.max_char_count = 0
        expect(textarea_type.valid?).to be_falsey
        expect(textarea_type.errors[:max_char_count]).to_not be_empty

        textarea_type.max_char_count = 1
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:max_char_count]).to be_empty

        textarea_type.max_char_count = 10
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:max_char_count]).to be_empty

        textarea_type.max_char_count = nil
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:max_char_count]).to be_empty
      end

      it 'should also be greater or equal than minimum_max_char_count_allowed' do
        expect(textarea_type).to receive(:minimum_max_char_count_allowed).at_least(1).times.and_return 10

        textarea_type.max_char_count = 0
        expect(textarea_type.valid?).to be_falsey
        expect(textarea_type.errors[:max_char_count]).to_not be_empty

        textarea_type.max_char_count = 10
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:max_char_count]).to be_empty

        textarea_type.max_char_count = 100
        expect(textarea_type.valid?).to be_truthy
        expect(textarea_type.errors[:max_char_count]).to be_empty
      end
    end
  end

  context 'public methods' do
    describe 'length_constraints?' do
      it 'should be true if there is a max_char_count constraint' do
        textarea_type.min_char_count = nil
        textarea_type.max_char_count = 10
        expect(textarea_type.length_constraints?).to be_truthy
      end

      it 'should be true if there is a min_char_count constraint' do
        textarea_type.min_char_count = 0
        textarea_type.max_char_count = nil
        expect(textarea_type.length_constraints?).to be_truthy
      end

      it 'should be false if there are no constraints' do
        textarea_type.min_char_count = nil
        textarea_type.max_char_count = nil
        expect(textarea_type.length_constraints?).to be_falsey
      end
    end

    describe 'minimum_max_char_count_allowed' do
      it 'should never less than 1 even if min_char_count is equal to 0' do
        textarea_type.min_char_count = 0
        expect(textarea_type.minimum_max_char_count_allowed).to eq 1
      end

      it 'should return 1 if there are not min_char_count defined' do
        textarea_type.min_char_count = nil
        expect(textarea_type.minimum_max_char_count_allowed).to eq 1
      end

      it 'should return the same value as min_char_count as long as its greather than 0' do
        textarea_type.min_char_count = 1
        expect(textarea_type.minimum_max_char_count_allowed).to eq 1

        textarea_type.min_char_count = 10
        expect(textarea_type.minimum_max_char_count_allowed).to eq 10
      end
    end
  end
end
