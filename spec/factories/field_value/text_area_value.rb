FactoryGirl.define do
  factory :text_area_value, class: FieldValue::TextAreaValue, parent: :field_value do
    value "lorem ispum"
  end
end
