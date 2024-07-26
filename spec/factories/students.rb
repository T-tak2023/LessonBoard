FactoryBot.define do
  factory :student do
    sequence(:student_name) { |n| "Student #{n}" }
    sequence(:email) { |n| "student#{n}@example.com" }
    password { "password" }
    course { "Course" }
    enrollment_date { Date.today }
    association :instructor
  end
end
