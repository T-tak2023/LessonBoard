FactoryBot.define do
  factory :instructor do
    email { "instructor@example.com" }
    password { "password" }
    password_confirmation { "password" }
    instructor_name { "Test Instructor" }
  end
end
