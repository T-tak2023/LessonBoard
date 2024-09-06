class LessonsController < ApplicationController
  before_action :authenticate_instructor! # Ensure the user is logged in as an instructor
  before_action :set_lesson, only: %i(show edit update destroy)

  def index
    @lessons = Lesson.where(instructor_id: current_instructor.id)

    respond_to do |format|
      format.html
      format.json do
        render json: @lessons.as_json(
          only: [:id, :start_time, :end_time, :status, :instructor_id, :student_id],
          methods: [:student_name, :instructor_name]
        )
      end
    end
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
          only: [:id, :start_time, :end_time, :status, :instructor_id, :student_id],
          methods: [:student_name]
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
      redirect_to @lesson, notice: 'Lesson was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to lessons_url, notice: 'Lesson was successfully destroyed.'
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:start_time, :end_time, :instructor_id, :student_id, :status)
  end
end