class LessonsController < ApplicationController
  before_action :authenticate_instructor!, except: [:student_index]
  before_action :authenticate_student!, only: [:student_index]
  before_action :set_lesson, only: %i(show edit update destroy)

  def index
    @lessons = Lesson.where(instructor_id: current_instructor.id)

    respond_to do |format|
      format.html
      format.json do
        render json: @lessons.as_json(
          only: [:id, :start_time, :end_time, :location, :status, :instructor_id, :student_id],
          methods: [:student_name, :instructor_name]
        )
      end
    end
  end

  def student_index
    @lessons = Lesson.where(student_id: current_student.id).
      where('start_time >= ?', Time.current.beginning_of_day)
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.instructor = current_instructor
    if @lesson.save
      render json: {
        success: true,
        lesson: @lesson.as_json(
          only: [:id, :start_time, :end_time, :location, :status, :instructor_id, :student_id],
          methods: [:student_name, :instructor_name]
        ),
      }
    else
      render json: { success: false, errors: @lesson.errors.full_messages }
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      render json: {
        success: true,
        lesson: @lesson.as_json(
          only: [:id, :start_time, :end_time, :location, :status, :instructor_id, :student_id],
          methods: [:student_name]
        ),
      }
    else
      render json: { success: false, errors: @lesson.errors.full_messages }
    end
  end

  def destroy
    if @lesson.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: @lesson.errors.full_messages }
    end
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:start_time, :end_time, :location, :status, :instructor_id, :student_id)
  end
end
