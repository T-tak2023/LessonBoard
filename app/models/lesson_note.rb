class LessonNote < ApplicationRecord
  mount_uploader :image_material, ImageMaterialUploader
  belongs_to :instructor
  belongs_to :student, optional: true

  validates :lesson_date, presence: true
  validates :content, :instructor_memo, :student_memo, length: { maximum: 500 }
  validates :video_material,
    format: {
      with: %r{\A(?:https?://)?(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/|m\.youtube\.com/watch\?v=)([a-zA-Z0-9_-]{11})(?:.*)\z},
      message: :invalid_youtube_url
    },
    allow_blank: true

  def student_name
    student&.student_name || '情報なし'
  end

  def instructor_name
    instructor.instructor_name
  end
end
