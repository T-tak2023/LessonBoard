FactoryBot.define do
  factory :lesson_note do
    student
    instructor { student.instructor }
    content { "Sample lesson note content" }
    instructor_memo { "Instructor's memo" }
    image_material { "image.jpg" }
    video_material { "https://www.youtube.com/watch?v=abcdefghijk" }
    student_memo { "Student's memo" }
    start_time { 1.day.ago }
    end_time { 1.day.ago + 1.hour }
    location { "Classroom" }
  end
end
