require 'rails_helper'

RSpec.describe Instructor, type: :model do
  context 'バリデーション' do
    it { should validate_presence_of(:instructor_name) }
    it { should validate_length_of(:instructor_name).is_at_most(20) }
    it { should validate_length_of(:course).is_at_most(50) }
  end

  context 'アソシエーション' do
    it { should have_many(:students) }
    it { should have_many(:lessons) }
  end
end
