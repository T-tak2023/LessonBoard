FactoryBot.define do
  factory :lesson_log do
    teacher_id { 1 }
    instructor_id { 1 }
    memo { "MyText" }
    instructor_memo { "MyText" }
    image_material { "MyString" }
    video_material { "MyString" }
  end
end
