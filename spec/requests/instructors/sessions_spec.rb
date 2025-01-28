require 'rails_helper'

RSpec.describe "Instructors::Sessions", type: :request do
  describe "GET /instructors/sign_in" do
    context "未ログイン状態" do
      it "ログインページが200ステータスを返す" do
        get new_instructor_session_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("講師ログイン")
      end
    end

    context "講師ログイン済みの場合" do
      let(:instructor) { create(:instructor) }

      before do
        sign_in instructor
      end

      it "ホームにリダイレクトされる" do
        get new_instructor_session_path
        expect(response).to redirect_to(root_path)
      end

      it "プロフィールページにアクセスできる" do
        get instructor_profile_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /instructors/sign_in" do
    let(:instructor) { create(:instructor) }

    context "有効な資格情報を送信した場合" do
      it "ログインに成功し、ホームにリダイレクトされる" do
        post instructor_session_path, params: { instructor: { email: instructor.email, password: instructor.password } }
        expect(response).to redirect_to(root_path)
        expect(controller.current_instructor).to eq(instructor)
      end
    end

    context "無効な資格情報を送信した場合" do
      it "ログインに失敗し、エラーメッセージが返される" do
        post instructor_session_path, params: { instructor: { email: "wrong@example.com", password: "wrongpassword" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("メールアドレスまたはパスワードが違います。")
      end
    end

    context "空の資格情報を送信した場合" do
      it "ログインに失敗し、エラーメッセージが返される" do
        post instructor_session_path, params: { instructor: { email: "", password: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("メールアドレスまたはパスワードが違います。")
      end
    end
  end

  describe "DELETE /instructors/sign_out" do
    let(:instructor) { create(:instructor) }

    before do
      sign_in instructor
    end

    it "ログアウト後にホームにリダイレクトされる" do
      delete destroy_instructor_session_path
      expect(response).to redirect_to(root_path)
      expect(controller.current_instructor).to be_nil
    end
  end

  describe "認証が必要なページへのアクセス制御" do
    it "未ログイン時、プロフィールページへのアクセスはログインページにリダイレクトされる" do
      get instructor_profile_path
      expect(response).to redirect_to(new_instructor_session_path)
    end

    it "未ログイン時、アカウント編集ページへのアクセスはログインページにリダイレクトされる" do
      get edit_instructor_registration_path
      expect(response).to redirect_to(new_instructor_session_path)
    end
  end
end
