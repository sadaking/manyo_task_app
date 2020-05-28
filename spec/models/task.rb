require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :model do
  it 'titleが空ならバリデーションが通らない' do
    task = Task.new(title: '', content: '万葉課題')
    expect(task).not_to be_valid
  end
  it 'contentが空ならバリデーションが通らない' do
    task = Task.new(title: '万葉', content: '')
    expect(task).not_to be_valid
  end
  it 'deadlineが空ならバリデーションが通らない' do
    task = Task.new(title: '万葉', content: '万葉課題', deadline: '')
    expect(task).not_to be_valid
  end
  it 'statusが空ならバリデーションが通らない' do
    task = Task.new(title: '万葉', content: '万葉課題', deadline: '2020-05-27', status: '')
    expect(task).not_to be_valid
  end
  it 'priorityが空ならバリデーションが通らない' do
    task = Task.new(title: '万葉', content: '万葉課題', deadline: '2020-05-27', status: '完了', priority: '')
    expect(task).not_to be_valid
  end
  it '内容が記載されていればバリデーションが通る' do
    task = Task.new(title: '万葉', content: '万葉課題', deadline: '2020-05-27', status: '完了', priority: '高')
    expect(task).to be_valid
  end
end

RSpec.describe 'scope検索', type: :model do
  context 'scopeメソッドで検索をした場合' do
    before do
      FactoryBot.create(:task)
      FactoryBot.create(:second_task)
    end
    it "scopeメソッドでタイトル検索ができる" do
      expect(Task.title_search('万葉').count).to eq 1
    end
    it "scopeメソッドでステータス検索ができる" do
      expect(Task.status_search('完了').count).to eq 2
    end
    it "scopeメソッドでタイトルとステータスの両方が検索できる" do
      expect(Task.title_search('万葉').status_search('完了').count).to eq 1
    end
  end
end
