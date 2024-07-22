class Instructor < ApplicationRecord
  mount_uploader :icon_image, IconImageUploader
  has_many :students
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
