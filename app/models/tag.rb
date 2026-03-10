class Tag < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :color, presence: true, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "は #RRGGBB 形式で入力してください" }
end
