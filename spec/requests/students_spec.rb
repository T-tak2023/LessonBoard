require 'rails_helper'

RSpec.describe "Students", type: :request do
  let(:instructor) { create(:instructor) }
  let!(:students) { create_list(:student, 5, instructor: instructor) }

  before do
    sign_in instructor
  end

  describe 'Instructors::Students' do
    describe 'GET /instructors/my-students' do
      pending it 'returns http success' do
        get instructors_students_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
