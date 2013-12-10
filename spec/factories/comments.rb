FactoryGirl.define do
  factory :comment do

    trait :deleted do
      deleted_at { Time.now.utc }
    end

    deleted_at nil

    factory :deleted_comment,   traits: [ :deleted ]
  end
end
