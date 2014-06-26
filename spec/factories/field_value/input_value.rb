FactoryGirl.define do
  factory :input_value, class: FieldValue::InputValue, parent: :field_value do
    value "lorem ipsum"
  end
end