require 'spec_helper'

describe FieldType::TextareaType do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:textarea_type) { FactoryGirl.build :textarea_type, _type: 'FieldType::TextareaType' }

  context 'building and validation on STI' do
    describe 'textarea_type' do
      it 'should build successfully and be valid' do
        expect(textarea_type.valid?).to be_truthy
      end
    end
  end
end
