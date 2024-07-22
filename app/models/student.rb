class Student < ApplicationRecord
  belongs_to :instructor
  before_create :set_enrollment_date
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def set_enrollment_date
    self.enrollment_date = Date.today
  end
end
