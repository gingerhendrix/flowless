FactoryGirl.define do
  factory :input_value, class: FieldValue::InputValue, parent: :field_value do
    value "lorem ipsum"

    trait :current do
      current true
    end

    factory :current_input_value, traits: [ :current ]
  end
end