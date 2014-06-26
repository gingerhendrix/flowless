require 'spec_helper'

describe FieldType do
  let(:field_type) { FactoryGirl.build :field_type }

  context 'building and validation on STI' do
    describe 'base field_type' do
      it 'should build successfully and be invalid' do
        expect(field_type.valid?).to be_falsey
      end
    end
  end
end
