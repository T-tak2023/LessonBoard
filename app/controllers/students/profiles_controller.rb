class Students::ProfilesController < ApplicationController
  before_action :authenticate_student!, only: %i(profile profile_edit profile_update)
  before_action :ensure_normal_user, only: %i(profile_edit profile_update)

  def profile
    @student = current_student
  end

  def profile_edit
    @student = current_student
  end

  def profile_update
    @student = current_student
    if @student.update(profile_params)
      redirect_to students_profile_path, notice: 'プロフィールが更新されました'
    else
      render 'profile_edit'
    end
  end

  private

  def profile_params
    params.require(:student).permit(:icon_image)
  end

  def ensure_normal_user
    if current_student.guest_user?
      flash[:alert] = 'ゲストユーザーは編集できません。'
      redirect_to student_profile_path
    end
  end
end
