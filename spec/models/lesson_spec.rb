require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:instructor) }
    it { should validate_presence_of(:student) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:location).is_at_most(255) }

    context '時刻のバリデーション' do
      let(:time) { Time.now }

      context 'end_time が start_time より前の場合' do
        let(:lesson) { build(:lesson, start_time: time, end_time: time - 1.hour) }

        it '無効であること' do
          lesson.valid?
          expect(lesson.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'start_time と end_time が同じ時刻の場合' do
        let(:lesson) { build(:lesson, start_time: time, end_time: time) }

        it '無効であること' do
          lesson.valid?
          expect(lesson.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'end_time が start_time より後の場合' do
        let(:lesson) { build(:lesson, start_time: time, end_time: time + 1.hour) }

        it '有効であること' do
          expect(lesson).to be_valid
        end
      end
    end

    context 'status のバリデーション' do
      context '無効な値の場合' do
        let(:lesson) { build(:lesson, status: '無効な値') }

        it '無効であること' do
          expect(lesson).to be_invalid
          expect(lesson.errors[:status]).to include('は一覧にありません')
        end
      end

      context '有効な値の場合' do
        let(:valid_statuses) { %w(確定 保留 キャンセル) }

        it '有効であること' do
          valid_statuses.each do |status|
            lesson = build(:lesson, status: status)
            expect(lesson).to be_valid
          end
        end
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:instructor) }
    it { should belong_to(:student) }
  end

  describe '#student_name' do
    let(:student) { create(:student, student_name: 'John Doe') }
    let(:lesson) { create(:lesson, student: student) }

    it '生徒名を返すこと' do
      expect(lesson.student_name).to eq('John Doe')
    end
  end

  describe '#instructor_name' do
    let(:instructor) { create(:instructor, instructor_name: 'Jane Doe') }
    let(:lesson) { create(:lesson, instructor: instructor) }

    it '講師名を返すこと' do
      expect(lesson.instructor_name).to eq('Jane Doe')
    end
  end
end
