FactoryGirl.define do

  sequence(:random_string) { |n| Faker::Lorem.sentence(5) }

  factory :post do
    title   { generate(:random_string) }
    content { generate(:random_string) }
  end

  factory :role do
    name 'foo'

    factory :admin_role do
      name 'admin'
    end
  end

  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password              { 'foobar' }
    password_confirmation { 'foobar' }
    activated true

    factory :not_activated_user do
      activated false
    end

    factory :admin do
      after(:create) do |user|
        admin_role = create(:admin_role)
        user.assignments.create!(role_id: admin_role.id)
      end
    end
  end
end
