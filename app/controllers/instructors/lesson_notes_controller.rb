class Instructors::LessonNotesController < ApplicationController
  before_action :authenticate_instructor!
  before_action :set_lesson_note, only: [:show, :edit, :update, :destroy]

  def index
    @lesson_notes = LessonNote.where(instructor_id: current_instructor.id).order(start_time: :desc)
  end

  def new
    @lesson_note = LessonNote.new
    @students = Student.where(instructor_id: current_instructor.id)
  end

  def create
    @lesson_note = LessonNote.new(lesson_note_params)
    @lesson_note.instructor = current_instructor
    if @lesson_note.save
      redirect_to instructors_lesson_note_path(@lesson_note), notice: 'レッスンノートが作成されました。'
    else
      @students = Student.where(instructor_id: current_instructor.id)
      render :new
    end
  end

  def show
    @embed_url = generate_embed_url(@lesson_note.video_material)
  end

  def edit
    @students = Student.where(instructor_id: current_instructor.id)
  end

  def update
    if @lesson_note.update(lesson_note_params)
      redirect_to instructors_lesson_note_path(@lesson_note), notice: 'レッスンノートが更新されました。'
    else
      @students = Student.where(instructor_id: current_instructor.id)
      render :edit
    end
  end

  def destroy
    if @lesson_note.destroy
      redirect_to instructors_lesson_notes_path, notice: 'レッスンノートが削除されました。'
    else
      redirect_to instructors_lesson_notes_path, alert: 'レッスンノートの削除に失敗しました。'
    end
  end

  private

  def set_lesson_note
    @lesson_note = LessonNote.find_by(id: params[:id])

    if @lesson_note.nil?
      redirect_to instructors_lesson_notes_path, alert: '指定されたレッスンノートは存在しません。'
    elsif @lesson_note.instructor_id != current_instructor.id
      redirect_to instructors_lesson_notes_path, alert: '指定されたレッスンノートにはアクセスできません。'
    end
  end

  def generate_embed_url(material)
    return nil if material.blank?

    video_id = extract_youtube_id(material)
    video_id.present? ? "https://www.youtube.com/embed/#{video_id}" : nil
  end

  def extract_youtube_id(url)
    return nil if url.blank?

    patterns = [
      /youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})/,
      /youtu\.be\/([a-zA-Z0-9_-]{11})/,
      /m\.youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})/,
    ]

    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end

    nil
  end

  def lesson_note_params
    params.require(:lesson_note).permit(
      :instructor_id,
      :student_id,
      :start_time,
      :end_time,
      :content,
      :instructor_memo,
      :image_material,
      :video_material,
    )
  end
end
