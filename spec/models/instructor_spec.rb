require 'rails_helper'

RSpec.describe Instructor, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:instructor_name) }
    it { should validate_length_of(:instructor_name).is_at_most(20) }
    it { should validate_length_of(:course).is_at_most(50) }
  end

  describe 'アソシエーション' do
    it { should have_many(:students).dependent(:destroy) }
    it { should have_many(:lessons).dependent(:destroy) }
    it { should have_many(:lesson_notes).dependent(:destroy) }

    context 'instructor を削除した時' do
      let(:instructor) { create(:instructor) }

      it '関連する students も削除されること' do
        create(:student, instructor: instructor)
        expect { instructor.destroy }.to change { Student.count }.by(-1)
      end

      it '関連する lessons も削除されること' do
        create(:lesson, instructor: instructor)
        expect { instructor.destroy }.to change { Lesson.count }.by(-1)
      end

      it '関連する lesson_notes も削除されること' do
        create(:lesson_note, instructor: instructor)
        expect { instructor.destroy }.to change { LessonNote.count }.by(-1)
      end
    end
  end

  describe '画像アップロード' do
    let(:instructor) { build(:instructor) }

    context '有効な画像の場合' do
      %w(jpg jpeg png).each do |format|
        it "#{format}形式の画像をアップロードできること" do
          instructor.icon_image = Rack::Test::UploadedFile.new(
            Rails.root.join("spec/fixtures/files/valid_image.#{format}"), "image/#{format}"
          )
          expect(instructor).to be_valid
        end
      end

      it 'アップロードされた画像が200x200にリサイズされること' do
        instructor.icon_image = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/valid_image.jpg'), 'image/jpeg'
        )
        instructor.save
        expect(instructor.icon_image).to be_present

        uploaded_image = MiniMagick::Image.open(instructor.icon_image.file.file)

        expect(uploaded_image[:width]).to eq(200)
        expect(uploaded_image[:height]).to eq(200)
      end
    end

    context '無効な画像の場合' do
      it '2MBを超える画像は無効であること' do
        large_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/large_image.jpg'), 'image/jpeg')
        instructor.icon_image = large_image
        expect(instructor).to be_invalid
        expect(instructor.errors[:icon_image]).to include('ファイルサイズが大きすぎます。最大2MBまで許可されています。')
      end

      it '許可されていない拡張子のファイルは無効であること' do
        instructor.icon_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample.txt'), 'text/plain')
        expect(instructor).to be_invalid
        expect(instructor.errors[:icon_image]).to include('としてアップロードできるファイルタイプは[jpg, jpeg, png]です。')
      end
    end
  end
end
