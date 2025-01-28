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

  describe 'icon_image のアップロード' do
    let(:student) { build(:student) }

    context '有効な画像の場合' do
      %w(jpg jpeg png).each do |format|
        it "#{format}形式の画像をアップロードできること" do
          student.icon_image = Rack::Test::UploadedFile.new(
            Rails.root.join("spec/fixtures/files/icon_images/valid_image.#{format}"), "image/#{format}"
          )
          expect(student).to be_valid
        end
      end

      it 'アップロードされた画像が200x200にリサイズされること' do
        student.icon_image = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/icon_images/valid_image.jpg'), 'image/jpeg'
        )
        student.save
        expect(student.icon_image).to be_present

        uploaded_image = MiniMagick::Image.open(student.icon_image.file.file)

        expect(uploaded_image[:width]).to eq(200)
        expect(uploaded_image[:height]).to eq(200)
      end
    end

    context '無効な画像の場合' do
      it '2MBを超える画像は無効であること' do
        large_image = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/icon_images/large_image.jpg'), 'image/jpeg'
        )
        student.icon_image = large_image
        expect(student).to be_invalid
        expect(student.errors[:icon_image]).to include('ファイルサイズが大きすぎます。最大2MBまで許可されています。')
      end

      it '許可されていない拡張子のファイルは無効であること' do
        student.icon_image = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/icon_images/sample.txt'), 'text/plain'
        )
        expect(student).to be_invalid
        expect(student.errors[:icon_image]).to include('としてアップロードできるファイルタイプは[jpg, jpeg, png]です。')
      end
    end
  end
end
