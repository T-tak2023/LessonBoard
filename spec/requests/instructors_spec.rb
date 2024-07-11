require 'rails_helper'

RSpec.describe "Instructors", type: :request do
  describe "GET /profile" do
    let(:instructor) { create(:instructor) }

    before do
      sign_in instructor
    end

    it "returns http success" do
      get instructor_profile_path
      expect(response).to have_http_status(:success)
    end
  end
end
