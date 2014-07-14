FactoryGirl.define do
  factory :field_type do
    sequence(:index) {|n| n }
    sequence(:name)  {|n| "my field #{n}"}

    trait :with_help_info do
      help_info "Lorem ipsum dolor sit amet, consectetuer adipiscing elit,\nsed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat"
    end

    trait :mandatory do
      optional false
    end

    trait :unique do
      uniq true
    end

    factory :mandatory_field_type,      traits: [ :mandatory ]
    factory :unique_field_type,           traits: [ :unique ]
    factory :field_type_with_help_info, traits: [ :with_help_info ]
    factory :full_field_type,           traits: [ :mandatory, :unique, :with_help_info ]
  end
end
