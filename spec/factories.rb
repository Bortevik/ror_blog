FactoryGirl.define do

  sequence(:random_string) { |n| Faker::Lorem.sentence(5) }

  factory :post do
    title { generate(:random_string) }
    content { generate(:random_string) }
  end
end