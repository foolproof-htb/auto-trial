FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "タグ #{n}" }
    color { "#6366f1" }
  end
end
