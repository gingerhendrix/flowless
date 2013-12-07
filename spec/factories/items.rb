FactoryGirl.define do
  factory :item do
    flow  { FactoryGirl.build :flow }
    user  { FactoryGirl.build :user }
  end
end