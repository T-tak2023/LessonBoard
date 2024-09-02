class Lesson < ApplicationRecord
  belongs_to :instructor
  belongs_to :student

  validates :start_time, :end_time, :instructor, :student, :status, presence: true
end

def student_name
  student.student_name # student インスタンスから名前を取得
end

def instructor_name
  instructor.instructor_name
end

# rubocop:disable Airbnb/ModuleMethodInWrongFile

# rubocop:enable Airbnb/ModuleMethodInWrongFile
