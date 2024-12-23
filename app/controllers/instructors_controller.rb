class InstructorsController < ApplicationController
  before_action :authenticate_instructor!, only: %i(profile profile_edit profile_update)
  before_action :ensure_normal_user, only: %i[profile_edit profile_update]

  def profile
    @instructor = current_instructor
  end

  def profile_edit
    @instructor = current_instructor
  end

  def profile_update
    @instructor = current_instructor
    if @instructor.update(profile_params)
      redirect_to instructor_profile_path
    else
      render "profile_edit"
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:profile_update, keys: [:icon_image, :instructor_name, :course])
  end

  def profile_params
    params.require(:instructor).permit(:icon_image, :instructor_name, :course)
  end

  def ensure_normal_user
    if current_instructor.guest_user?
      flash[:alert] = 'ゲストユーザーは編集できません。'
      redirect_to instructor_profile_path
    end
  end
end
