FactoryGirl.define do

  sequence(:random_string) { |n| Faker::Lorem.sentence(5) }

  factory :post do
    title   { generate(:random_string) }
    content { generate(:random_string) }
  end

  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password              { 'foobar' }
    password_confirmation { 'foobar' }
  end
end