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

    context '時刻のバリデーション' do
      context 'end_time が start_time より前の場合' do
        it '無効であること' do
          lesson_note.start_time = Time.now
          lesson_note.end_time = Time.now - 1.hour
          expect(lesson_note).to_not be_valid
          expect(lesson_note.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'start_time と end_time が同じ時刻の場合' do
        it '無効であること' do
          time = Time.now
          lesson_note.start_time = time
          lesson_note.end_time = time
          lesson_note.valid?
          expect(lesson_note.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'end_time が start_time より後の場合' do
        it '有効であること' do
          lesson_note.start_time = Time.now
          lesson_note.end_time = Time.now + 1.hour
          expect(lesson_note).to be_valid
        end
      end
    end

    context 'video_materialのバリデーション' do
      context 'YouTube以外のURLの場合' do
        it '無効であること' do
          lesson_note.video_material = "https://example.com/invalid"
          expect(lesson_note).to_not be_valid
          expect(lesson_note.errors[:video_material]).to include('は有効なYouTubeのURLを入力してください。')
        end
      end

      context '正しいYouTube URLの場合' do
        it '有効であること' do
          lesson_note.video_material = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
          expect(lesson_note).to be_valid
        end
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:instructor) }
    it { should belong_to(:student).optional }

    context '関連する student が削除された場合' do
      it 'lesson_note は削除されないこと' do
        student = create(:student)
        create(:lesson_note, student: student)

        expect { student.destroy }.not_to change { LessonNote.count }
      end

      it 'lesson_note の student_id は nil になること' do
        student = create(:student)
        lesson_note = create(:lesson_note, student: student)

        student.destroy
        lesson_note.reload
        expect(lesson_note.student_id).to be_nil
      end

      it 'lesson_note は有効であること' do
        student = create(:student)
        lesson_note = create(:lesson_note, student: student)

        student.destroy
        lesson_note.reload
        expect(lesson_note).to be_valid
      end
    end
  end
end
