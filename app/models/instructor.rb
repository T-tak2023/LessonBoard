class Instructor < ApplicationRecord
  mount_uploader :icon_image, IconImageUploader
  has_many :students, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :lesson_notes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :instructor_name, presence: true, length: { maximum: 20 }
  validates :course, length: { maximum: 50 }

  def self.guest
    guest_instructor = find_or_create_by!(email: 'guest_instructor@example.com') do |instructor|
      instructor.password = SecureRandom.urlsafe_base64
      instructor.instructor_name = 'ゲスト 講師'
    end

    Student.find_or_create_by!(email: 'guest_student@example.com') do |student|
      student.password = SecureRandom.urlsafe_base64
      student.student_name = 'ゲスト 生徒'
      student.instructor = guest_instructor
    end

    guest_instructor
  end

  def guest_user?
    email == 'guest_instructor@example.com'
  end
end
