require 'rails_helper'

RSpec.describe LessonNote, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_length_of(:location).is_at_most(255) }
    it { should validate_length_of(:content).is_at_most(500) }
    it { should validate_length_of(:instructor_memo).is_at_most(500) }
    it { should validate_length_of(:student_memo).is_at_most(500) }

    context '時刻のバリデーション' do
      let(:time) { Time.now }

      context 'end_time が start_time より前の場合' do
        let(:lesson_note) { build(:lesson_note, start_time: time, end_time: time - 1.hour) }

        it '無効であること' do
          lesson_note.valid?
          expect(lesson_note.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'start_time と end_time が同じ時刻の場合' do
        let(:lesson_note) { build(:lesson_note, start_time: time, end_time: time) }

        it '無効であること' do
          lesson_note.valid?
          expect(lesson_note.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'end_time が start_time より後の場合' do
        let(:lesson_note) { build(:lesson_note, start_time: time, end_time: time + 1.hour) }

        it '有効であること' do
          expect(lesson_note).to be_valid
        end
      end
    end

    context 'video_material のバリデーション' do
      let(:lesson_note) { build(:lesson_note) }

      context '正常系' do
        context 'YouTubeのURL' do
          it '基本形式（youtube.com/watch?=v）が有効であること' do
            lesson_note.video_material = "https://www.youtube.com/watch?v=ABC_123-xyz"
            expect(lesson_note).to be_valid
          end

          it '短縮形式（youtu.be）が有効であること' do
            lesson_note.video_material = "https://youtu.be/ABC_123-xyz"
            expect(lesson_note).to be_valid
          end

          it 'モバイル形式（m.youtube.com）が有効であること' do
            lesson_note.video_material = "https://m.youtube.com/watch?v=ABC_123-xyz"
            expect(lesson_note).to be_valid
          end

          it 'クエリパラメータ付きのURLが有効であること' do
            lesson_note.video_material = "https://www.youtube.com/watch?v=ABC_123-xyz?feature=shared"
            expect(lesson_note).to be_valid
          end

          it 'wwwなしのURLが有効であること' do
            lesson_note.video_material = "https://youtube.com/watch?v=ABC_123-xyz"
            expect(lesson_note).to be_valid
          end

          it 'プロトコルなしのURLが有効であること' do
            lesson_note.video_material = "www.youtube.com/watch?v=ABC_123-xyz"
            expect(lesson_note).to be_valid
          end
        end

        context '空値' do
          it '空文字が有効であること' do
            lesson_note.video_material = ""
            expect(lesson_note).to be_valid
          end

          it 'nilが有効であること' do
            lesson_note.video_material = nil
            expect(lesson_note).to be_valid
          end
        end
      end

      context '異常系' do
        context 'URL形式の基本的なエラー' do
          it 'URLではない文字列は無効であること' do
            lesson_note.video_material = "これはURLではありません"
            expect(lesson_note).to_not be_valid
          end

          it 'マルチバイト文字を含むURLは無効であること' do
            lesson_note.video_material = "https://www.youtube.com/watch?v=あいうえお12345"
            expect(lesson_note).to_not be_valid
          end
        end

        context 'YouTube以外のURL' do
          it '他のドメインのURLは無効であること' do
            lesson_note.video_material = "https://example.com/watch?v=ABC_123-xyz"
            expect(lesson_note).to_not be_valid
          end

          it 'YouTubeに似たドメインのURLは無効であること' do
            lesson_note.video_material = "https://youtube.fake.com/watch?v=ABC_123-xyz"
            expect(lesson_note).to_not be_valid
          end
        end

        context 'YouTube URLの形式エラー' do
          it '動画IDが11文字未満の場合は無効であること' do
            lesson_note.video_material = "https://www.youtube.com/watch?v=ABC_123"
            expect(lesson_note).to_not be_valid
          end

          it '動画IDに不正な文字が含まれる場合は無効であること' do
            lesson_note.video_material = "https://www.youtube.com/watch?v=ABC_123#xyz"
            expect(lesson_note).to_not be_valid
          end

          it 'watch?v=がないURLは無効であること' do
            lesson_note.video_material = "https://www.youtube.com/ABC_123-xyz"
            expect(lesson_note).to_not be_valid
          end
        end
      end

      it 'エラー時には適切なメッセージが設定されること' do
        lesson_note.video_material = "https://example.com/invalid"
        lesson_note.valid?
        expect(lesson_note.errors[:video_material]).to include('は有効なYouTubeのURLを入力してください。')
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:instructor) }
    it { should belong_to(:student).optional }

    context '関連する student が削除された場合' do
      let(:student) { create(:student) }
      let!(:lesson_note) { create(:lesson_note, student: student) }

      it 'lesson_note は削除されないこと' do
        expect { student.destroy }.not_to change { LessonNote.count }
      end

      it 'lesson_note の student_id は nil になること' do
        student.destroy
        lesson_note.reload
        expect(lesson_note.student_id).to be_nil
      end

      it 'lesson_note は有効であること' do
        student.destroy
        lesson_note.reload
        expect(lesson_note).to be_valid
      end
    end
  end

  describe '#student_name' do
    let(:student) { create(:student, student_name: 'John Doe') }

    context '生徒が存在する場合' do
      let(:lesson_note) { create(:lesson_note, student: student) }

      it '生徒名を返すこと' do
        expect(lesson_note.student_name).to eq('John Doe')
      end
    end

    context '生徒が存在しない場合' do
      let(:instructor) { create(:instructor) }
      let(:lesson_note) { create(:lesson_note, student: nil, instructor: instructor) }

      it '「情報なし」を返すこと' do
        expect(lesson_note.student_name).to eq('情報なし')
      end
    end
  end

  describe '#instructor_name' do
    let(:instructor) { create(:instructor, instructor_name: 'Jane Doe') }
    let(:lesson_note) { create(:lesson_note, instructor: instructor) }

    it '講師名を返すこと' do
      expect(lesson_note.instructor_name).to eq('Jane Doe')
    end
  end
end
