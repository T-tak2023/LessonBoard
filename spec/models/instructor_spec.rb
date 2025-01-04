require 'rails_helper'

RSpec.describe Instructor, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:instructor_name) }
    it { should validate_length_of(:instructor_name).is_at_most(20) }
    it { should validate_length_of(:course).is_at_most(50) }
  end

  describe 'アソシエーション' do
    it { should have_many(:students) }
    it { should have_many(:lessons) }

    context 'instructorを削除した時の動作' do
      it 'instructorが削除されると関連するstudentsも削除される' do
        instructor = create(:instructor)
        create(:student, instructor: instructor)
        expect { instructor.destroy }.to change { Student.count }.by(-1)
      end

      it 'instructorが削除されると関連するlessonsも削除される' do
        instructor = create(:instructor)
        create(:lesson, instructor: instructor)
        expect { instructor.destroy }.to change { Lesson.count }.by(-1)
      end

      it 'instructorが削除されると関連するlesson_notesも削除される' do
        instructor = create(:instructor)
        create(:lesson_note, instructor: instructor)
        expect { instructor.destroy }.to change { LessonNote.count }.by(-1)
      end
    end
  end
end
