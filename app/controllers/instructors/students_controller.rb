class Instructors::StudentsController < ApplicationController
  before_action :authenticate_instructor!, only: %i(index show edit update destroy)
  before_action :set_student, only: %i(show edit update destroy)

  def index
    @students = current_instructor.students
  end

  def show
    @lessons = @student.lessons.where('start_time >= ?', Time.current.beginning_of_day)
    @lesson_notes = @student.lesson_notes.order(start_time: :desc)
  end

  def edit
  end

  def update
    if @student.update(student_params_for_instructor)
      redirect_to instructors_student_path(@student), notice: 'プロフィールが更新されました'
    else
      render 'edit'
    end
  end

  def destroy
    if @student.destroy
      redirect_to instructors_students_path, notice: '生徒が削除されました'
    else
      redirect_to instructors_students_path, alert: '生徒の削除に失敗しました'
    end
  end

  private

  def set_student
    @student = Student.find_by(id: params[:id])

    if @student.nil?
      redirect_to instructors_students_path, alert: '指定されたIDの生徒は存在しません。'
    elsif @student.instructor_id != current_instructor.id
      redirect_to instructors_students_path, alert: '指定されたIDの生徒にはアクセスできません。'
    end
  end

  def student_params_for_instructor
    params.require(:student).permit(:student_name, :email, :course, :enrollment_date)
  end
end
