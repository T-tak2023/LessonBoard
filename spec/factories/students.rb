FactoryBot.define do
  factory :student do
    email { "student@example.com" }
    password { "password" }
    password_confirmation { "password" }
    student_name { "Test Student" }
    course { "Sample Course" }
    enrollment_date { Date.today }
    association :instructor
  end
end
