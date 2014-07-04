require 'rails_helper'

describe FieldValue::EmailValue, :type => :model do
  let(:item)              { FactoryGirl.build :item }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_type)        { FactoryGirl.build :email_type, _type: 'FieldType::EmailType' }
  # forced to add the _type parameters for using zeus, cf https://github.com/burke/zeus/issues/439
  let(:field_container)   { FactoryGirl.build :field_container, item: item, field_type_id: field_type.id }
  let(:email_value)       { FactoryGirl.build :email_value, _type: 'FieldValue::EmailValue', field_container: field_container }

  before :each do
    allow(field_container).to receive(:field_type).and_return field_type
  end

  context 'building and validation on STI' do
    describe 'email_value' do
      it 'should build successfully and be valid' do
        expect(email_value.valid?).to be_truthy
      end
    end
  end

  context 'validations' do

    describe 'blocked keywords' do
      it 'should call forbidden_keyword_validation when there are blocked_keywords' do
        expect(email_value).to receive(:blocked_keywords).and_return [ 'some_keywords' ]
        expect(email_value).to receive(:forbidden_keyword_validation)
        email_value.valid?
      end

      it 'should not call forbidden_keyword_validation when there are no blocked_keywords' do
        expect(email_value).to     receive(:blocked_keywords).and_return [ ]
        expect(email_value).to_not receive(:forbidden_keyword_validation)
        email_value.valid?
      end

      it 'should raise an error if the email value contains a blocked keyword' do
        expect(email_value).to receive(:blocked_keywords).and_return [ 'blocked' ]
        email_value.value = 'someone@blocked.com'
        expect(email_value.forbidden_keyword_validation).to_not eq false
        expect(email_value.errors[:value]).to_not be_empty
      end

      it 'should not raise an error if the email value does not contain a blocked keyword' do
        expect(email_value).to receive(:blocked_keywords).and_return [ 'blocked' ]
        email_value.value = 'someone@ok.com'
        expect(email_value.forbidden_keyword_validation).to_not eq false
        expect(email_value.errors[:value]).to be_empty
      end
    end

    describe 'when multiple_email_allowed is not allowed' do
      before :each do
        expect(email_value).to receive(:multiple_emails?).at_least(1).times.and_return false
      end

      it 'should allow one single email to be valid' do
        email_value.value = 'one@email.com'
        expect(email_value.valid?).to be_truthy
      end

      it 'should not allow more than one single email to be valid' do
        email_value.value = 'one@email.com, two@emails.com'
        expect(email_value.valid?).to be_falsy
      end

      it 'should allows allow the email value to be nil or blank but not some random value' do
        email_value.value = " "
        expect(email_value.valid?).to be_truthy

        email_value.value = nil
        expect(email_value.valid?).to be_truthy

        email_value.value = "x"
        expect(email_value.valid?).to be_falsy
      end
    end

    describe 'when multiple_email_allowed is allowed' do
      before :each do
        expect(email_value).to receive(:multiple_emails?).at_least(1).times.and_return true
      end

      it 'should allow one single email to be valid' do
        email_value.value = 'one@email.com'
        expect(email_value.valid?).to be_truthy
      end

      it 'should not allow more than one single email to be valid' do
        email_value.value = 'one@email.com, two@emails.com'
        expect(email_value.valid?).to be_truthy
      end

      it 'should allows allow the email value to be nil or blank but not some random value' do
        email_value.value = " "
        expect(email_value.valid?).to be_truthy

        email_value.value = nil
        expect(email_value.valid?).to be_truthy

        email_value.value = "x"
        expect(email_value.valid?).to be_falsy
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