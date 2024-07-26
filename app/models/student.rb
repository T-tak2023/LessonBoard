class Student < ApplicationRecord
  mount_uploader :icon_image, IconImageUploader
  belongs_to :instructor
  has_many :lessons
  before_create :set_enrollment_date
  validates :student_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def set_enrollment_date
    self.enrollment_date = Date.today
  end
end
