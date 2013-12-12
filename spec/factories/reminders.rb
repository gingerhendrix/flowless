FactoryGirl.define do
  factory :reminder do

    trait :public do
      private     false
    end

    trait :completed do
      complete    true
    end

    trait :recurring do
      recurrence  { Hash[:every, 'week', :on, ['monday', 'friday']] }
    end

    user          { FactoryGirl.build(:user) }
    remind_at     { Time.now }
    message       'Lorem ipsum'
    complete      false
    private       true

    factory :public_reminder,               traits: [ :public ]
    factory :completed_reminder,            traits: [ :completed ]
    factory :public_and_completed_reminder, traits: [ :public, :completed ]
    factory :recurring_reminder,            traits: [ :recurring ]
  end
end
