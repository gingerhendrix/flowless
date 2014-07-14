require 'rails_helper'

describe FieldType, :type => :model do
  let(:field_type_no_type) { FactoryGirl.build :field_type }
  let(:field_type)         { FactoryGirl.build :field_type, _type: FieldType::TYPES.first }

  context 'building and validation on STI' do
    describe 'base field_type' do
      it 'should build successfully and be invalid because no field type were specified' do
        expect(field_type_no_type.valid?).to be_falsey
      end

      it 'should be valid' do
        expect(field_type.valid?).to be_truthy
      end

      [:optional, :unique].each do |boolean_field|
        {
          true  => ['true', 't', 'TRUE', 'T', 'True', '1', 'Yes', 'Y', 'y', 'yes', 'YES', :true, 1, -1, true],
          false => ['false', 'f', 'FALSE', 'F', 'False', '0', 'No', 'N', 'n', 'no', 'No', :false, 0, 42, -42, false, 'random'],
        }.each do |result, possible_values|
          possible_values.each do |possible_value|
            it "should transform '#{boolean_field}' boolean field to proper boolean value ('#{result}') from '#{possible_value}'" do
              field_type[boolean_field] = possible_value
              expect(field_type.send(boolean_field)).to eq result
            end
          end
        end
      end
    end
  end

  context 'public methods' do
    describe 'unique?' do
      it 'should be unique?' do
        field_type.unique = true
        expect(field_type.unique?).to be_truthy
      end

      it 'should not be unique?' do
        field_type.unique = false
        expect(field_type.unique?).to be_falsey
      end
    end
  end
end
