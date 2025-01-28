FactoryBot.define do
  factory :instructor do
    sequence(:email) { |n| "instructor#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    instructor_name { "Test Instructor" }
  end
end
