class Lesson < ApplicationRecord
  belongs_to :instructor
  belongs_to :student

  validates :start_time, :end_time, :instructor, :student, :status, presence: true
end
