class Instructors::LessonNotesController < ApplicationController
  before_action :authenticate_instructor!
  before_action :set_lesson_note, only: [:show, :edit, :update, :destroy]

  def index
    @lesson_notes = LessonNote.where(instructor_id: current_instructor.id).order(lesson_date: :desc)
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
      redirect_to instructors_lesson_note_path(@lesson_note), notice: 'レッスンログが更新されました。'
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
    params.require(:lesson_note).permit(
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
