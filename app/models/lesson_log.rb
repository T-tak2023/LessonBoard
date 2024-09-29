class LessonLog < ApplicationRecord
  mount_uploader :image_material, ImageMaterialUploader
  belongs_to :instructor
  belongs_to :student

  validates :lesson_date, presence: true

  def student_name
    student.student_name
  end
end
