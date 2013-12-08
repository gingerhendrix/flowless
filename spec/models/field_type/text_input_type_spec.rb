require 'spec_helper'

describe FieldType::TextInputType do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:text_input_type) { FactoryGirl.build :text_input_type, _type: 'FieldType::TextInputType' }

  context 'building and validation on STI' do
    describe 'text_input_type' do
      it 'should build successfully and be valid' do
        expect(text_input_type.valid?).to be_true
      end
    end
  end
end
