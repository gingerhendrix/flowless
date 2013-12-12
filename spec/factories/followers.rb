FactoryGirl.define do
  factory :follower do

    trait :remindable do
      remindable      true
    end

    trait :not_remindable do
      remindable      false
    end

    user    { FactoryGirl.build(:user) }

    factory :not_remindable_follower, traits: [ :not_remindable ]
    factory :remindable_follower,     traits: [ :remindable ]
  end
end
