FactoryGirl.define do
  factory :text_markup_value, class: FieldValue::TextMarkupValue, parent: :field_value do
    value <<-TEXT
Lorem ipsum dolor sit amet, *consectetur* adipiscing elit. Mauris risus dui:

- lobortis vitae pulvinar nec, pharetra quis erat.
- Nunc a justo gravida, euismod erat quis,
- pharetra ligula.
`In id erat sed orci tempor molestie et a justo.` Morbi a congue tortor.

TEXT
  end
end
