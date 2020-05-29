class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum priority: {高:0, 中:1, 低:2}
  scope :title_search, -> (title) {where("title LIKE ?", "%#{title}%")}
  scope :status_search,  -> (status) {where(status: status)}
  belongs_to :user
end
