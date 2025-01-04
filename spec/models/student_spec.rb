require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:student_name) }
    it { should validate_length_of(:student_name).is_at_most(20) }
    it { should validate_length_of(:course).is_at_most(50) }
  end

  describe 'アソシエーション' do
    it { should belong_to(:instructor) }
    it { should have_many(:lessons).dependent(:destroy) }
    it { should have_many(:lesson_notes) }

    context 'studentを削除した時の動作' do
      it 'studentが削除されると関連するlessonも削除される' do
        student = create(:student)
        create(:lesson, student: student)
        expect { student.destroy }.to change { Lesson.count }.by(-1)
      end
    end
  end

  describe 'コールバック' do
    it '新規登録時に enrollment_date が自動設定されること' do
      student = build(:student, enrollment_date: nil)
      student.save
      expect(student.enrollment_date).to eq(Date.today)
    end
  end
end
