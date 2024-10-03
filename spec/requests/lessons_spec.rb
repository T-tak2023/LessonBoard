require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  let!(:instructor) { create(:instructor) }
  let!(:student) { create(:student, instructor: instructor) }
  let!(:lesson) { create(:lesson, instructor: instructor, student: student) }

  # describe "GET /lessons/new" do
  #   it "returns http success" do
  #     sign_in instructor # assuming Devise for authentication
  #     get "/lessons/new"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /lessons/edit" do
  #   it "returns http success" do
  #     sign_in instructor # assuming Devise for authentication
  #     get "/lessons/#{lesson.id}/edit"
  #     expect(response).to have_http_status(:success)
  #   end
  # end
end
