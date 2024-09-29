class LessonLog < ApplicationRecord
  belongs_to :instructor
  belongs_to :student

  def student_name
    student.student_name
  end
end
