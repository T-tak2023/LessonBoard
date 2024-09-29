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
    @lesson_log.video_material = handle_video_material(@lesson_log.video_material)
    if @lesson_log.save
      redirect_to @lesson_log, notice: 'レッスンログが作成されました。'
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
    new_video_material = handle_video_material(params[:lesson_log][:video_material])
    if @lesson_log.update(lesson_log_params.merge(video_material: new_video_material))
      redirect_to @lesson_log, notice: 'レッスンログが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @lesson_log = LessonLog.find(params[:id])
    if @lesson_log.destroy
      redirect_to lesson_logs_path, notice: 'レッスンログが削除されました。'
    else
      redirect_to lesson_logs_path, alert: 'レッスンログの削除に失敗しました。'
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

  def handle_video_material(material)
    if material.present? && material.include?("youtube.com")
      youtube_id = material.split("v=")[1].split("&")[0] rescue nil
      return "https://www.youtube.com/embed/#{youtube_id}" if youtube_id
    elsif material.present? && material.include?("youtu.be")
      youtube_id = material.split("/").last
      return "https://www.youtube.com/embed/#{youtube_id}" if youtube_id
    end
    nil
  end
end
