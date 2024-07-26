FactoryBot.define do
  factory :lesson do
    start_time { Time.now }
    end_time { Time.now + 1.hour }
    student
    instructor
    status { "Scheduled" }
  end
end
