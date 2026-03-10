class Task < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  enum :status, { pending: 0, in_progress: 1, done: 2 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true

  scope :by_due_date, -> { order(due_date: :asc) }
  scope :overdue, -> { where("due_date < ?", Date.today).where.not(status: :done) }
end
