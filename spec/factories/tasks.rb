FactoryBot.define do
  factory :task do
    title { '万葉' }
    content { '万葉課題' }
    deadline { '2020-05-27' }
    status { '完了' }
    priority { '高' }
  end
  factory :second_task, class: Task do
    title { 'twitter' }
    content { 'twitter作成' }
    deadline { '2020-05-28' }
    status { '完了' }
    priority { '中' }
  end
end
