class Lesson < ApplicationRecord
  belongs_to :instructor
  belongs_to :student

  validates :start_time, :end_time, :instructor, :student, :status, presence: true
end

# rubocop:disable Airbnb/ModuleMethodInWrongFile
def student_name
  student.student_name
end

def instructor_name
  instructor.instructor_name
end
# rubocop:enable Airbnb/ModuleMethodInWrongFile
