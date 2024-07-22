FactoryBot.define do
  factory :lesson do
    start_time { "2024-07-22 12:50:09" }
    end_time { "2024-07-22 12:50:09" }
    instructor { nil }
    student { nil }
    status { "MyString" }
  end
end
