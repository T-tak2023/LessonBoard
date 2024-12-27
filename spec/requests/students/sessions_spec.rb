require 'rails_helper'

RSpec.describe "Students::Sessions", type: :request do
  describe "GET /students/sign_in" do
    context "未ログイン状態" do
      it "ログインページが200ステータスを返す" do
        get new_student_session_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("生徒ログイン")
      end
    end

    context "生徒ログイン済みの場合" do
      let(:student) { create(:student) }

      before do
        sign_in student
      end

      it "ホームにリダイレクトされる" do
        get new_student_session_path
        expect(response).to redirect_to(root_path)
      end

      it "プロフィールページにアクセスできる" do
        get students_profile_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /students/sign_in" do
    let(:student) { create(:student) }

    context "有効な資格情報を送信した場合" do
      it "ログインに成功し、ホームにリダイレクトされる" do
        post student_session_path, params: { student: { email: student.email, password: student.password } }
        expect(response).to redirect_to(root_path)
        expect(controller.current_student).to eq(student)
        follow_redirect!
        expect(response.body).to include("ログインしました")
      end
    end

    context "無効な資格情報を送信した場合" do
      it "ログインに失敗し、エラーメッセージが返される" do
        post student_session_path, params: { student: { email: "wrong@example.com", password: "wrongpassword" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("メールアドレスまたはパスワードが違います。")
      end
    end

    context "空の資格情報を送信した場合" do
      it "ログインに失敗し、エラーメッセージが返される" do
        post student_session_path, params: { student: { email: "", password: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("メールアドレスまたはパスワードが違います。")
      end
    end
  end

  describe "DELETE /students/sign_out" do
    let(:student) { create(:student) }

    before do
      sign_in student
    end

    it "ログアウト後にホームにリダイレクトされる" do
      delete destroy_student_session_path
      expect(response).to redirect_to(root_path)
      expect(controller.current_student).to be_nil
    end
  end
end
