FactoryGirl.define do
  factory :step do

    trait :initial do
      initial     true
    end

    trait :terminal do
      terminal    true
    end

    name          "my_step"
    description   "lorem ispum"

    factory :initial_step,  traits: [ :initial ]
    factory :terminal_step, traits: [ :terminal ]
    factory :only_step,     traits: [ :initial, :terminal ]
  end
end
