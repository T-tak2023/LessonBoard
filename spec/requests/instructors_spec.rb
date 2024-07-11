require 'rails_helper'

RSpec.describe "Instructors", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/instructors/show"
      expect(response).to have_http_status(:success)
    end
  end

end
