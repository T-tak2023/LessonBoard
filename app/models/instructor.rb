class Instructor < ApplicationRecord
  mount_uploader :icon_image, IconImageUploader
  has_many :students
  has_many :lessons
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :instructor_name, presence: true, length: { maximum: 20 }
  validates :course, length: { maximum: 50 }

  def self.guest
    find_or_create_by!(email: 'guest_instructor@example.com') do |instructor|
      instructor.password = SecureRandom.urlsafe_base64
      instructor.instructor_name = 'ゲスト講師'
    end
  end

  def guest_user?
    email == 'guest_instructor@example.com'
  end
end
