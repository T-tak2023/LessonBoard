class InstructorsController < ApplicationController
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
end
