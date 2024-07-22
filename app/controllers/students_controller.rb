class StudentsController < ApplicationController
  before_action :authenticate_instructor!, only: [:index]
  before_action :authenticate_student!, only: [:profile, :profile_edit, :profile_update]

  def profile
    @student = current_student
  end

  def profile_edit
    @student = current_student
  end

  def profile_update
    @student = current_student
    if @student.update(profile_params)
      redirect_to student_profile_path, notice: 'プロフィールが更新されました'
    else
      render 'profile_edit'
    end
  end

  def index
    @students = current_instructor.students
  end

  private

  def authenticate_student!
    unless student_signed_in?
      redirect_to new_student_session_path, alert: 'ログインが必要です'
    end
  end

  def profile_params
    params.require(:student).permit(:student_name, :email, :course, :icon_image, :enrollment_date)
  end
end
