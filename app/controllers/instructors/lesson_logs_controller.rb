class Instructors::LessonLogsController < ApplicationController
  before_action :authenticate_instructor!

  def index
    @lesson_logs = LessonLog.where(instructor_id: current_instructor.id).order(lesson_date: :desc)
  end

  def new
    @lesson_log = LessonLog.new
    @students = Student.where(instructor_id: current_instructor.id)
  end

  def create
    @lesson_log = LessonLog.new(lesson_log_params)
    @lesson_log.instructor = current_instructor
    if @lesson_log.save
      redirect_to instructors_lesson_log_path(@lesson_log), notice: 'レッスンログが作成されました。'
    else
      @students = Student.where(instructor_id: current_instructor.id)
      render :new
    end
  end

  def show
    @lesson_log = LessonLog.find(params[:id])
    @embed_url = generate_embed_url(@lesson_log.video_material)
  end

  def edit
    @lesson_log = LessonLog.find(params[:id])
    @students = Student.where(instructor_id: current_instructor.id)
  end

  def update
    @lesson_log = LessonLog.find(params[:id])
    if @lesson_log.update(lesson_log_params)
      redirect_to instructors_lesson_log_path(@lesson_log), notice: 'レッスンログが更新されました。'
    else
      @students = Student.where(instructor_id: current_instructor.id)
      render :edit
    end
  end

  def destroy
    @lesson_log = LessonLog.find(params[:id])
    if @lesson_log.destroy
      redirect_to instructors_lesson_logs_path, notice: 'レッスンログが削除されました。'
    else
      redirect_to instructors_lesson_logs_path, alert: 'レッスンログの削除に失敗しました。'
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

  def generate_embed_url(material)
    return nil if material.blank?

    if material.include?("youtube.com")
      begin
        youtube_id = material.split("v=").last.split("&").first
      rescue NoMethodError, IndexError
        nil
      end
      return "https://www.youtube.com/embed/#{youtube_id}" if youtube_id
    elsif material.include?("youtu.be")
      youtube_id = material.split("/").last
      return "https://www.youtube.com/embed/#{youtube_id}" if youtube_id.present?
    end

    nil
  end
end
