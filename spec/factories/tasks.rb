FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "タスク #{n}" }
    description { "タスクの説明" }
    status { :pending }
    due_date { 7.days.from_now.to_date }
  end
end
