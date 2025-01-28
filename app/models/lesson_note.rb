class LessonNote < ApplicationRecord
  mount_uploader :image_material, ImageMaterialUploader
  belongs_to :instructor
  belongs_to :student, optional: true

  validates :start_time, :end_time, presence: true
  validates :location, length: { maximum: 255 }
  validates :content, length: { maximum: 500 }
  validates :instructor_memo, length: { maximum: 500 }
  validates :student_memo, length: { maximum: 500 }, allow_blank: true
  validates :video_material, format: {
    with: /\A(https:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/|m\.youtube\.com\/watch\?v=)[a-zA-Z0-9_-]{11}(\?.*)?\z/,
    message: :invalid_youtube_url,
  }, allow_blank: true
  validate :end_time_after_start_time

  def student_name
    student&.student_name || '情報なし'
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
