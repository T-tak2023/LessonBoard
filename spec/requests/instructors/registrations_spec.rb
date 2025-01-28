require 'rails_helper'

RSpec.describe 'Instructor::Registrations', type: :request do
  describe 'POST /instructors/sign_up' do
    context '有効な入力の場合' do
      let(:valid_params) { { instructor: attributes_for(:instructor) } }

      it '講師アカウントが作成されること' do
        expect {
          post instructor_registration_path, params: valid_params
        }.to change(Instructor, :count).by(1)
      end

      it '適切なレスポンスを返すこと' do
        post instructor_registration_path, params: valid_params
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_path)
      end
    end

    context '無効な入力の場合' do
      context 'メールアドレスが空の場合' do
        let(:invalid_email_params) { { instructor: attributes_for(:instructor, email: '') } }

        it '講師アカウントが作成されないこと' do
          expect {
            post instructor_registration_path, params: invalid_email_params
          }.not_to change(Instructor, :count)
        end

        it 'エラーレスポンスを返すこと' do
          post instructor_registration_path, params: invalid_email_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("メールアドレスを入力してください")
        end
      end

      context '既存のメールアドレスが使用された場合' do
        before do
          create(:instructor, email: 'existing@example.com')
        end

        let(:duplicate_params) { { instructor: attributes_for(:instructor, email: 'existing@example.com') } }

        it '講師アカウントが作成されないこと' do
          expect {
            post instructor_registration_path, params: duplicate_params
          }.not_to change(Instructor, :count)
        end

        it 'エラーレスポンスを返すこと' do
          post instructor_registration_path, params: duplicate_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("メールアドレスが既に使われています")
        end
      end

      context '講師名が空の場合' do
        let(:invalid_name_params) { { instructor: attributes_for(:instructor, instructor_name: '') } }

        it '講師アカウントが作成されないこと' do
          expect {
            post instructor_registration_path, params: invalid_name_params
          }.not_to change(Instructor, :count)
        end

        it 'エラーレスポンスを返すこと' do
          post instructor_registration_path, params: invalid_name_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("講師名を入力してください")
        end
      end

      context '講師名が20文字を超える場合' do
        let(:too_long_name_params) { { instructor: attributes_for(:instructor, instructor_name: 'a' * 21) } }

        it '講師アカウントが作成されないこと' do
          expect {
            post instructor_registration_path, params: too_long_name_params
          }.not_to change(Instructor, :count)
        end

        it 'エラーレスポンスを返すこと' do
          post instructor_registration_path, params: too_long_name_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("講師名は20文字以内で入力してください")
        end
      end

      context 'パスワードが空の場合' do
        let(:invalid_password_params) { { instructor: attributes_for(:instructor, password: '', password_confirmation: '') } }

        it '講師アカウントが作成されないこと' do
          expect {
            post instructor_registration_path, params: invalid_password_params
          }.not_to change(Instructor, :count)
        end

        it 'エラーレスポンスを返すこと' do
          post instructor_registration_path, params: invalid_password_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("パスワードを入力してください")
        end
      end

      context 'パスワード（確認用）とパスワードの入力が一致しない場合' do
        let(:mismatched_password_params) do
          { instructor: attributes_for(:instructor, password: 'password123', password_confirmation: 'different123') }
        end

        it '講師アカウントが作成されないこと' do
          expect {
            post instructor_registration_path, params: mismatched_password_params
          }.not_to change(Instructor, :count)
        end

        it 'エラーレスポンスを返すこと' do
          post instructor_registration_path, params: mismatched_password_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("パスワード（確認用）とパスワードの入力が一致しません")
        end
      end
    end
  end
end
