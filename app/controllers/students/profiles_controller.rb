class Students::ProfilesController < ApplicationController
  before_action :authenticate_student!, only: %i(profile profile_edit profile_update)

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

  private

  def profile_params
    params.require(:student).permit(:icon_image)
  end
end
