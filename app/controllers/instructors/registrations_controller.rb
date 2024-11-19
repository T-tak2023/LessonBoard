class Instructors::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: :destroy

  private

  def ensure_normal_user
    if resource.guest_user?
      flash[:alert] = 'ゲストユーザーは削除できません。'
      redirect_to edit_instructor_registration_path
    end
  end
end
