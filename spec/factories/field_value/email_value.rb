FactoryGirl.define do
  factory :email_value, class: FieldValue::EmailValue, parent: :field_value do
    value "lorem@ispum.com"
  end
end
