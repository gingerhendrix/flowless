require 'spec_helper'

describe FieldType::TextMarkupType do
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:text_markup_type) { FactoryGirl.build :text_markup_type, _type: 'FieldType::TextMarkupType' }

  context 'building and validation on STI' do
    describe 'text_markup_type' do
      it 'should build successfully and be valid' do
        expect(text_markup_type).to be_true
      end
    end
  end
end
