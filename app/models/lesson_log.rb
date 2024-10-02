class LessonLog < ApplicationRecord
  mount_uploader :image_material, ImageMaterialUploader
  belongs_to :instructor
  belongs_to :student

  validates :lesson_date, presence: true
  validates :video_material, format: {
    with: /\A(https:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/|m\.youtube\.com\/watch\?v=)[a-zA-Z0-9_-]{11}(\?.*)?\z/,
    message: :invalid_youtube_url,
  }, allow_blank: true

  def student_name
    student.student_name
  end
end
