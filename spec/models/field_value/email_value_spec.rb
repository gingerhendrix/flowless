require 'spec_helper'

describe FieldValue::EmailValue, :type => :model do
  let(:item)              { FactoryGirl.build :item }
  let(:field_container)   { FactoryGirl.build :field_container, item: item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)        { FactoryGirl.build :email_type, _type: 'FieldType::EmailType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:email_value)       { FactoryGirl.build :email_value, _type: 'FieldValue::EmailValue', field_container: field_container }

  context 'building and validation on STI' do
    before :each do
      expect(item.flow.field_types).to receive(:find).at_least(1).times.and_return field_type
    end

    describe 'email_value' do
      it 'should build successfully and be valid' do
        expect(email_value.valid?).to be_truthy
      end
    end
  end

  context 'testing email regexps' do
    describe 'SINGLE_EMAIL_REGEXP' do
      it 'should allow one those strings as email' do
        [
          "john@test.com",
          "john+tag@test.com",
          "john.doe@test.com",
          "john_doe@sub.test.com",
        ].each do |email|
          expect(email).to match FieldValue::EmailValue::SINGLE_EMAIL_REGEXP
        end
      end

      it 'should not allow one those strings as email' do
        [
          "john@test.com,",
          "john tag@test.com",
          "john.doe@test.com charles@test.com",
          "john.doe@test.com,charles@test.com",
          "John <john.doe@test.com>"
        ].each do |email|
          expect(email).to_not match FieldValue::EmailValue::SINGLE_EMAIL_REGEXP
        end
      end
    end

    describe 'MULTIPLE_EMAIL_REGEXP' do
      it 'should allow one those strings as mutiple emails' do
        [
          "john@test.com",
          "john.doe@test.com,charles@test.com",
          "john.doe@test.com ,  charles@test.com",
          "a@a.a,a@a.a ,a@a.a, a@a.a",
        ].each do |email|
          expect(email).to match FieldValue::EmailValue::MULTIPLE_EMAIL_REGEXP
        end
      end

      it 'should not allow one those strings as mutiple emails' do
        [
          "john@test.com,",
          "john tag@test.com",
          "john.doe@test.com charles@test.com",
          "John <john.doe@test.com>, Charles <charles@test.com>",
        ].each do |email|
          expect(email).to_not match FieldValue::EmailValue::MULTIPLE_EMAIL_REGEXP
        end
      end
    end
  end
end