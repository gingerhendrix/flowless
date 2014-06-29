require 'spec_helper'

describe FieldType::InputType, :type => :model do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:input_type) { FactoryGirl.build :input_type, _type: 'FieldType::InputType' }

  context 'building and validation on STI' do
    describe 'input_type' do
      it 'should build successfully and be valid' do
        expect(input_type.valid?).to be_truthy
      end
    end
  end
end
