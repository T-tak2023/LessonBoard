class Lesson < ApplicationRecord
  belongs_to :instructor
  belongs_to :student

  validates :start_time, :end_time, :instructor, :student, :status, presence: true
  validate :end_time_after_start_time

   # rubocop:disable Airbnb/ModuleMethodInWrongFile
  def student_name
    student.student_name
  end

  def instructor_name
    instructor.instructor_name
  end
  # rubocop:enable Airbnb/ModuleMethodInWrongFile

  private

  def end_time_after_start_time
    if end_time <= start_time
      errors.add(:end_time, "は開始時間より後の時刻を選択してください")
    end
  end
end
