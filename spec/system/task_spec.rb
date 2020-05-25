require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    # 「タスク一覧画面」や「タスク詳細画面」などそれぞれのテストケースで、before内のコードが実行される
    # 各テストで使用するタスクを1件作成する
    # 作成したタスクオブジェクトを各テストケースで呼び出せるようにインスタンス変数に代入
    @task = FactoryBot.create(:task, title: 'task', content: 'submit task', deadline: '2020-05-23')
    @second_task = FactoryBot.create(:task, title: 'new_task',content: 'difficult task', deadline: '2020-05-24')
  end
  describe 'タスク一覧画面' do
    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示される' do
        # beforeに必要なタスクデータが作成されるので、ここでテストデータ作成処理を書く必要がない
        visit tasks_path
        expect(page).to have_content 'task'
        expect(page).to have_content 'new_task'
      end
    end
    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいる' do
        # あらかじめタスク並び替えの確認テストで使用するためのタスクを二つ作成する
        # （上記と全く同じ記述が繰り返されてしまう！）
        visit tasks_path

        task_list = all('.task_row') # タスク一覧を配列として取得するため、View側でidを振っておく

        expect(task_list[0]).to have_content 'new_task'
        expect(task_list[1]).to have_content 'task'
      end
    end
  end
  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存される' do
        visit new_task_path
        fill_in 'タスク名', with: '万葉課題'
        fill_in 'タスク詳細', with: '万葉課題の提出'
        fill_in '終了期限', with: '2020/05/23'
        click_on "登録する"
        expect(page).to have_content '万葉課題の提出'
      end
    end
  end
  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移する' do
         task_id = FactoryBot.create(:task, title: 'dive_text', content: 'submit task', deadline: '2020-05-23')
         visit task_path(task_id)
         expect(page).to have_content 'dive_text', 'submit task'
       end
     end
  end
end
