class Students::LessonLogsController < ApplicationController
  before_action :authenticate_student!
  before_action :set_lesson_log, only: [:show, :edit, :update]

  def index
    @lesson_logs = LessonLog.where(student_id: current_student.id).order(lesson_date: :desc)
  end

  def show
    @embed_url = generate_embed_url(@lesson_log.video_material)
  end

  def edit
  end

  def update
    if @lesson_log.update(lesson_log_params)
      redirect_to students_lesson_log_path(@lesson_log), notice: 'メモが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_lesson_log
    @lesson_log = LessonLog.find_by(id: params[:id])

    if @lesson_log.nil?
      redirect_to students_lesson_logs_path, alert: '指定されたレッスンログは存在しません。'
    elsif @lesson_log.student_id != current_student.id
      redirect_to students_lesson_logs_path, alert: '指定されたレッスンログにはアクセスできません。'
    end
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

  def lesson_log_params
    params.require(:lesson_log).permit(:student_memo)
  end
end
