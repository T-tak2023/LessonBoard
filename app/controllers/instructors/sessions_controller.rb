class Instructors::SessionsController < ApplicationController
  def guest_sign_in
    instructor = Instructor.guest
    sign_in instructor
    redirect_to root_path, notice: 'ゲスト講師ユーザーとしてログインしました。'
  end
end
