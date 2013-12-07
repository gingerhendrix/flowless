FactoryGirl.define do
  factory :flow do
    sequence(:name) {|n|   "Flow #{n}" }
    user            { FactoryGirl.build :user }
  end
end
