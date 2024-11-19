class Student < ApplicationRecord
  mount_uploader :icon_image, IconImageUploader
  belongs_to :instructor
  has_many :lessons, dependent: :destroy
  has_many :lesson_notes
  before_create :set_enrollment_date

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :student_name, presence: true, length: { maximum: 20 }
  validates :course, length: { maximum: 50 }

  def self.guest
    find_or_create_by!(email: 'guest_student@example.com') do |student|
      student.password = SecureRandom.urlsafe_base64
      student.student_name = 'ゲスト生徒'

      instructor = Instructor.first || Instructor.create!(instructor_name: 'ゲスト講師', email: 'guest_instructor@example.com')
      student.instructor = instructor
    end
  end

  def guest_user?
    email == 'guest_student@example.com'
  end

  private

  def set_enrollment_date
    self.enrollment_date = Date.today
  end
end
