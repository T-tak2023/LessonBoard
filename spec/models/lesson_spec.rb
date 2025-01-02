require 'rails_helper'

RSpec.describe Lesson, type: :model do
  context 'バリデーション' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:instructor) }
    it { should validate_presence_of(:student) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:location).is_at_most(255) }

    it 'end_timeはstart_timeより後の時刻でなければ無効' do
      lesson = build(:lesson, start_time: Time.now, end_time: Time.now - 1.hour)
      lesson.valid?
      expect(lesson.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
    end

    it 'start_timeとend_timeが同じ時刻なら無効' do
      time = Time.now
      lesson = build(:lesson, start_time: time, end_time: time)
      lesson.valid?
      expect(lesson.errors[:end_time]).to include('は開始時間より後の時刻を選択してください')
    end

    it 'end_timeがstart_timeより後であれば有効' do
      lesson = build(:lesson, start_time: Time.now, end_time: Time.now + 1.hour)
      expect(lesson).to be_valid
    end

    it 'statusが無効な値であれば無効' do
      lesson = build(:lesson, status: '無効な値')
      expect(lesson).to be_invalid
      expect(lesson.errors[:status]).to include('は一覧にありません')
    end

    it 'statusが有効な値であれば有効' do
      valid_statuses = %w(確定 保留 キャンセル)
      valid_statuses.each do |status|
        lesson = build(:lesson, status: status)
        expect(lesson).to be_valid
      end
    end
  end

  context 'アソシエーション' do
    it { should belong_to(:instructor) }
    it { should belong_to(:student) }

    it 'instructorが削除されると関連するlessonも削除される' do
      instructor = create(:instructor)
      create(:lesson, instructor: instructor)  # lessonを作成するだけで変数に代入しない
      expect { instructor.destroy }.to change { Lesson.count }.by(-1)
    end

    it 'studentが削除されると関連するlessonも削除される' do
      student = create(:student)
      create(:lesson, student: student)  # lessonを作成するだけで変数に代入しない
      expect { student.destroy }.to change { Lesson.count }.by(-1)
    end
  end

  context 'インスタンスメソッド' do
    it 'student_nameメソッドが生徒名を返す' do
      student = create(:student, student_name: 'John Doe')
      lesson = create(:lesson, student: student)
      expect(lesson.student_name).to eq('John Doe')
    end

    it 'instructor_nameメソッドが講師名を返す' do
      instructor = create(:instructor, instructor_name: 'Jane Doe')
      lesson = create(:lesson, instructor: instructor)
      expect(lesson.instructor_name).to eq('Jane Doe')
    end
  end
end
