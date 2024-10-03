class Students::LessonLogsController < ApplicationController
  before_action :authenticate_student!

  def index
    @lesson_logs = LessonLog.where(student_id: current_student.id).order(lesson_date: :desc)
  end

  def show
    @lesson_log = LessonLog.find(params[:id])
    @embed_url = generate_embed_url(@lesson_log.video_material)
  end

  private

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
