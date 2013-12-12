FactoryGirl.define do
  factory :event do
    trait :read do
      read_at       { Time.now.utc }
    end

    entity_class    'Object'
    entity_id       42
    action          { Event::ACTIONS.first }
    read_at         nil
    data            { Hash[:lorem, :ipsum] }
    user            { FactoryGirl.build(:user) }

    factory :read_event,  traits: [ :read ]
  end
end
