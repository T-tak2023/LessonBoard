class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :restrict_unauthorized_access

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:instructor_name, :instructor_id, :enrollment_date, :student_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:student_name])
  end

  def restrict_unauthorized_access
    if instructor_signed_in? && on_student_related_page?
      flash[:alert] = "講師アカウントでは生徒用ページにアクセスできません。"
      redirect_to root_path
    elsif student_signed_in? && on_instructor_related_page?
      flash[:alert] = "生徒アカウントでは講師用ページにアクセスできません。"
      redirect_to root_path
    end
  end

  def on_student_related_page?
    request.path.start_with?("/students")
  end

  def on_instructor_related_page?
    request.path.start_with?("/instructors")
  end
end
