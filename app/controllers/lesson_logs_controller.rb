class LessonLogsController < ApplicationController
  before_action :authenticate_instructor!

  def index
    @lesson_logs = LessonLog.where(instructor_id: current_instructor.id)
  end

  def new
    @lesson_log = LessonLog.new
    @students = Student.where(instructor_id: current_instructor.id)
  end

  def create
    @lesson_log = LessonLog.new(lesson_log_params)
    @lesson_log.instructor = current_instructor
    if @lesson_log.save
      redirect_to lesson_logs_path, notice: 'レッスンログが作成されました。'
    else
      render :new
    end
  end

  def show
    @lesson_log = LessonLog.find(params[:id])
  end

  def edit
    @lesson_log = LessonLog.find(params[:id])
    @students = Student.where(instructor_id: current_instructor.id)
  end

  def update
    @lesson_log = LessonLog.find(params[:id])
    if @lesson_log.update(lesson_log_params)
      redirect_to lesson_logs_path, notice: 'レッスンログが更新されました。'
    else
      render :edit
    end
  end

  private

  def lesson_log_params
    params.require(:lesson_log).permit(
      :instructor_id,
      :student_id,
      :lesson_date,
      :content,
      :instructor_memo,
      :image_material,
      :video_material,
      :log_status
    )
  end
end
