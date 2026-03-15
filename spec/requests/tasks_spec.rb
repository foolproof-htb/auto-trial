require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "POST /tasks" do
    let(:tag) { create(:tag) }
    let(:valid_params) do
      {
        task: {
          title: "テストタスク",
          description: "説明",
          status: "pending",
          due_date: 7.days.from_now.to_date,
          tag_ids: [ tag.id ]
        }
      }
    end

    it "tag_idsをStrong Parameters経由で許可しタスクを作成する" do
      expect {
        post tasks_path, params: valid_params
      }.to change(Task, :count).by(1)

      task = Task.last
      expect(task.tag_ids).to include(tag.id)
    end

    it "tag_idsに空文字が含まれていても正しく処理する" do
      params_with_blank = valid_params.deep_merge(task: { tag_ids: [ "", tag.id.to_s ] })
      expect {
        post tasks_path, params: params_with_blank
      }.to change(Task, :count).by(1)

      expect(Task.last.tag_ids).to include(tag.id)
    end
  end

  describe "PATCH /tasks/:id" do
    let(:task) { create(:task) }
    let(:tag) { create(:tag) }
    let(:another_tag) { create(:tag) }

    it "tag_idsをStrong Parameters経由で許可しタスクを更新する" do
      task.tags << another_tag

      patch task_path(task), params: {
        task: {
          title: task.title,
          tag_ids: [ tag.id ]
        }
      }

      task.reload
      expect(task.tag_ids).to include(tag.id)
      expect(task.tag_ids).not_to include(another_tag.id)
    end
  end
end
