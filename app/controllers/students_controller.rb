class StudentsController < ApplicationController
  before_action :authenticate_instructor!, only: %i(index show edit update destroy)
  before_action :authenticate_student!, only: %i(profile profile_edit profile_update)
  before_action :set_student, only: %i(show edit update destroy)

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

  def show
  end

  def edit
  end

  def update
    if @student.update(student_params_for_instructor)
      redirect_to student_path(@student), notice: 'プロフィールが更新されました'
    else
      render 'edit'
    end
  end

  def destroy
    if @student.destroy
      redirect_to students_path, notice: '生徒が削除されました'
    else
      redirect_to students_path, alert: '生徒の削除に失敗しました'
    end
  end

  private

  def set_student
    @student = Student.find_by(id: params[:id])

    if @student.nil?
      redirect_to students_path, alert: '指定されたIDの生徒は存在しません。'
    elsif @student.instructor_id != current_instructor.id
      redirect_to students_path, alert: '指定されたIDの生徒にはアクセスできません。'
    end
  end

  def profile_params
    params.require(:student).permit(:email, :icon_image)
  end

  def student_params_for_instructor
    params.require(:student).permit(:student_name, :email, :course, :enrollment_date)
  end
end
