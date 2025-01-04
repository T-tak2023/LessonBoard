require 'rails_helper'

RSpec.describe LessonNote, type: :model do
  describe 'バリデーション' do
    let(:lesson_note) { build(:lesson_note) }

    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_length_of(:location).is_at_most(255) }
    it { should validate_length_of(:content).is_at_most(500) }
    it { should validate_length_of(:instructor_memo).is_at_most(500) }
    it { should validate_length_of(:student_memo).is_at_most(500) }

    context 'start_timeとend_timeに関するバリデーション' do
      it 'end_timeはstart_timeより後の時刻でなければ無効' do
        lesson_note.start_time = Time.now
        lesson_note.end_time = Time.now - 1.hour
        expect(lesson_note).to_not be_valid
        expect(lesson_note.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
      end

      it 'start_timeとend_timeが同じ時刻なら無効' do
        time = Time.now
        lesson_note.start_time = time
        lesson_note.end_time = time
        lesson_note.valid?
        expect(lesson_note.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
      end

      it 'end_timeがstart_timeより後であれば有効' do
        lesson_note.start_time = Time.now
        lesson_note.end_time = Time.now + 1.hour
        expect(lesson_note).to be_valid
      end
    end

    context 'video_materialに関するバリデーション' do
      it 'YouTube以外のURLでは無効となる' do
        lesson_note.video_material = "https://example.com/invalid"
        expect(lesson_note).to_not be_valid
        expect(lesson_note.errors[:video_material]).to include('は有効なYouTubeのURLを入力してください。')
      end

      it '正しいYouTube URLの場合は有効' do
        lesson_note.video_material = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        expect(lesson_note).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:instructor) }
    it { should belong_to(:student).optional }

    context 'lesson_noteのアソシエーション関連の動作' do
      it 'studentが削除されても関連するlesson_noteは削除されず有効である' do
        student = create(:student)
        lesson_note = create(:lesson_note, student: student)
        expect { student.destroy }.not_to change { LessonNote.count }

        lesson_note.reload
        expect(lesson_note.student_id).to be_nil
        expect(lesson_note).to be_valid
      end
    end
  end
end
