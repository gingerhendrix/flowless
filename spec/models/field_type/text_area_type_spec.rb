require 'spec_helper'

describe FieldType::TextAreaType do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:text_area_type) { FactoryGirl.build :text_area_type, _type: 'FieldType::TextAreaType' }

  context 'building and validation on STI' do
    describe 'text_area_type' do
      it 'should build successfully and be valid' do
        expect(text_area_type.valid?).to be_true
      end
    end
  end
end
