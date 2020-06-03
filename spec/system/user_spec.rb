require 'rails_helper'
RSpec.describe 'ユーザ登録・ログイン・ログアウト機能', type: :system do
  describe 'ユーザ登録のテスト' do
    context 'ユーザのデータがなくログインしていない場合' do
      it 'ユーザ新規登録のテスト' do
        visit new_user_path
        fill_in 'user[name]', with: 'sample'
        fill_in 'user[email]', with: 'sample@example.com'
        fill_in 'user[password]', with: '00000000'
        fill_in 'user[password_confirmation]', with: '00000000'
        click_on '登録する'
        expect(page).to have_content "ユーザーを作成しました"
      end
      it 'ログインしていない時はログイン画面に飛ぶテスト' do
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe "セッション機能のテスト" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "ユーザーデータがあってまだログインしていない場合" do
      it "ログインができること" do
        visit new_session_path
        fill_in 'session_email', with: @user.email
        fill_in 'session_password', with: @user.password
        click_on "ログイン"
        expect(current_path).to eq user_path(id: @user.id)
      end
    end

    context "ユーザーのデータがあってログインしている場合" do
      before do
        visit new_session_path
        fill_in "session_email", with: "sample@example.com"
        fill_in "session_password", with: "00000000"
        click_on "ログイン"
      end

      it "自分の詳細画面(マイページ)に飛べること" do
        visit user_path(id: @user.id)
        expect(current_path).to eq user_path(id: @user.id)
      end

      it "一般ユーザが他人の詳細画面に飛ぶとタスク一覧ページに遷移すること" do
        @admin_user = FactoryBot.create(:admin_user)
        visit user_path(id: @admin_user.id)
        expect(page).to have_content "他の人のページへアクセスは出来ません"
      end

      it "ログアウトができること" do
       visit user_path(id: @user.id)
       click_on "Logout"
       expect(page).to have_content "ログアウトしました"
     end
    end
  end

  describe "管理画面のテスト" do
    context "管理者ユーザーを持っている場合" do
      it "管理者は管理画面にアクセスできること" do
        FactoryBot.create(:admin_user)
        visit new_session_path
        fill_in "session_email", with: "admin@example.com"
        fill_in "session_password" , with: "11111111"
        click_on "ログイン"
        visit admin_users_path
        expect(page).to have_content "管理画面"
      end
    end

    context "一般ユーザーでログインをしている場合" do
      it "一般ユーザは管理画面にアクセスできないこと" do
        FactoryBot.create(:user)
        visit new_session_path
        fill_in "session_email", with: "sample@example.com"
        fill_in "session_password", with: "00000000"
        click_on "ログイン"
        visit admin_users_path
        expect(page).to have_content "あなたは管理者ではありません"
      end
    end

    context "管理者がすでにログインしている場合" do
      before do
        FactoryBot.create(:admin_user)
        visit new_session_path
        fill_in "session_email", with: "admin@example.com"
        fill_in "session_password", with: "11111111"
        click_on "ログイン"
        visit admin_users_path
      end

      it "管理者はユーザを新規登録できること" do
        click_on "新規登録"
        fill_in "user_name", with: "admin_test"
        fill_in "user_email", with: "admin_test@example.com"
        fill_in "user_password", with: "3333333"
        fill_in "user_password_confirmation", with: "3333333"
        click_on "登録する"
        expect(page).to have_content "admin_test"
      end

      it  "管理者はユーザの詳細画面にアクセスできること" do
       @user = FactoryBot.create(:user)
       visit admin_user_path(id: @user.id)
       expect(page).to have_content "sample"
      end

      it "管理者はユーザの編集画面からユーザを編集できること" do
        @user = FactoryBot.create(:user)
        visit edit_admin_user_path(id: @user.id)
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example.com'
        click_button '登録する'
        expect(page).to have_content "test"
      end

      it "管理者はユーザの削除をできること" do
        @user = FactoryBot.create(:user)
        visit admin_users_path
        click_on "削除", match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "ユーザー「sample」を削除しました"
      end
    end
  end
end
