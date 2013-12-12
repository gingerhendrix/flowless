FactoryGirl.define do
  factory :transition do
    name                'my_transition'
    description         'lorem ipsum'
    source_step         { FactoryGirl.build(:initial_step) }
    destination_step    { FactoryGirl.build(:terminal_step) }
  end
end
