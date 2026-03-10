require "rails_helper"

RSpec.describe Task, type: :model do
  describe "バリデーション" do
    it "title があれば有効" do
      task = build(:task)
      expect(task).to be_valid
    end

    it "title が空なら無効" do
      task = build(:task, title: "")
      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it "title が255文字を超えると無効" do
      task = build(:task, title: "a" * 256)
      expect(task).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it "タグを複数持てる" do
      task = create(:task)
      tag1 = create(:tag)
      tag2 = create(:tag)
      task.tags << [tag1, tag2]
      expect(task.tags.count).to eq(2)
    end
  end

  describe "enum" do
    it "pending / in_progress / done の3ステータスを持つ" do
      expect(Task.statuses.keys).to contain_exactly("pending", "in_progress", "done")
    end
  end

  describe "scope" do
    it "overdue は期限切れで未完了のタスクのみ返す" do
      overdue = create(:task, due_date: 1.day.ago, status: :pending)
      create(:task, due_date: 1.day.ago, status: :done)
      create(:task, due_date: 1.day.from_now, status: :pending)
      expect(Task.overdue).to contain_exactly(overdue)
    end
  end
end
