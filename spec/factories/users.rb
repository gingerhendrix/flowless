FactoryGirl.define do
  factory :user do

    trait :only_admin do
      roles [ "admin" ]
    end

    trait :only_moderator do
      roles [ "moderator" ]
    end

    trait :admin do
      after(:build) do |user|
        user.roles = (user.roles << "admin")
      end
    end

    trait :moderator do
      after(:build) do |user|
        user.roles = (user.roles << "moderator")
      end
    end

    trait :no_name do
      first_name            nil
      last_name             nil
    end

    sequence(:email) {|n|   "factory_#{n}@example.com" }
    password                "password"
    password_confirmation   "password"
    first_name              "John"
    last_name               "Doe"
    roles                   [ "user" ]

    factory :user_no_name,   traits: [ :no_name ]
    factory :user_admin,     traits: [ :only_admin ]
    factory :user_moderator, traits: [ :only_moderator ]
    factory :user_all_roles, traits: [ :admin, :moderator ]
  end
end