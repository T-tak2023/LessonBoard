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
      context 'end_time が start_time より前の場合' do
        it '無効であること' do
          lesson = build(:lesson, start_time: Time.now, end_time: Time.now - 1.hour)
          lesson.valid?
          expect(lesson.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'start_time と end_time が同じ時刻の場合' do
        it '無効であること' do
          time = Time.now
          lesson = build(:lesson, start_time: time, end_time: time)
          lesson.valid?
          expect(lesson.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
        end
      end

      context 'end_time が start_time より後の場合' do
        it '有効であること' do
          lesson = build(:lesson, start_time: Time.now, end_time: Time.now + 1.hour)
          expect(lesson).to be_valid
        end
      end
    end

    context 'statusのバリデーション' do
      context '無効な値の場合' do
        it '無効であること' do
          lesson = build(:lesson, status: '無効な値')
          expect(lesson).to be_invalid
          expect(lesson.errors[:status]).to include('は一覧にありません')
        end
      end

      context '有効な値の場合' do
        it '有効であること' do
          valid_statuses = %w(確定 保留 キャンセル)
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
    it 'student_nameメソッドが生徒名を返すこと' do
      student = create(:student, student_name: 'John Doe')
      lesson = create(:lesson, student: student)
      expect(lesson.student_name).to eq('John Doe')
    end
  end

  describe '#instructor_name' do
    it 'instructor_nameメソッドが講師名を返すこと' do
      instructor = create(:instructor, instructor_name: 'Jane Doe')
      lesson = create(:lesson, instructor: instructor)
      expect(lesson.instructor_name).to eq('Jane Doe')
    end
  end
end
