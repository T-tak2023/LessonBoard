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
    it { should have_many(:lesson_notes).dependent(:nullify) }

    context 'student を削除した時' do
      let(:student) { create(:student) }
      let!(:lesson) { create(:lesson, student: student) }
      let!(:lesson_note) { create(:lesson_note, student: student) }

      it '関連する lesson も削除されること' do
        expect { student.destroy }.to change { Lesson.count }.by(-1)
      end

      it '関連する lesson_notes の student_id が null になること' do
        student.destroy
        expect(lesson_note.reload.student_id).to be_nil
      end
    end
  end

  describe 'コールバック' do
    let(:student) { build(:student, enrollment_date: nil) }

    it '新規登録時に enrollment_date が自動設定されること' do
      student.save
      expect(student.enrollment_date).to eq(Date.today)
    end
  end
end
