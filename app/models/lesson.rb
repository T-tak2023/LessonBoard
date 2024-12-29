class Lesson < ApplicationRecord
  belongs_to :instructor
  belongs_to :student

  validates :start_time, :end_time, :instructor, :student, :status, presence: true
  validates :location, length: { maximum: 255 }
  validate :end_time_after_start_time

  def student_name
    student.student_name
  end

  def instructor_name
    instructor.instructor_name
  end

  private

  def end_time_after_start_time
    if start_time.nil? || end_time.nil?
      return
    end

    if end_time <= start_time
      errors.add(:end_time, "は開始時間より後の時刻を選択してください")
    end
  end
end
