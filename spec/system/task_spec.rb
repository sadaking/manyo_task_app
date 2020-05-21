require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク一覧画面' do
    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示される' do
        task = FactoryBot.create(:task, title: 'task')
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end
  end
  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存される' do
        visit new_task_path
        fill_in 'タスク名', with: '万葉課題'
        fill_in 'タスク詳細', with: '万葉課題の提出'
        click_on "登録する"
        expect(page).to have_content '万葉課題の提出'
      end
    end
  end
  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移する' do
         task_id = FactoryBot.create(:task, title: 'dive_text', content: 'submit task')
         visit task_path(task_id)
         expect(page).to have_content 'dive_text', 'submit task'
       end
     end
  end
end