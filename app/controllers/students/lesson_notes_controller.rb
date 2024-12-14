class Students::LessonNotesController < ApplicationController
  before_action :authenticate_student!
  before_action :set_lesson_note, only: [:show, :edit, :update]

  def index
    @lesson_notes = LessonNote.where(student_id: current_student.id).order(start_time: :desc)
  end

  def show
    @embed_url = generate_embed_url(@lesson_note.video_material)
  end

  def edit
  end

  def update
    if @lesson_note.update(lesson_note_params)
      redirect_to students_lesson_note_path(@lesson_note), notice: 'メモが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_lesson_note
    @lesson_note = LessonNote.find_by(id: params[:id])

    if @lesson_note.nil?
      redirect_to students_lesson_notes_path, alert: '指定されたレッスンノートは存在しません。'
    elsif @lesson_note.student_id != current_student.id
      redirect_to students_lesson_notes_path, alert: '指定されたレッスンノートにはアクセスできません。'
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

  def lesson_note_params
    params.require(:lesson_note).permit(:student_memo)
  end
end
