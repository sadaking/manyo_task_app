class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true

  scope :title_search, -> (title) {where("title LIKE ?", "%#{title}%")}
  scope :status_search,  -> (status) {where(status: status)}
end
