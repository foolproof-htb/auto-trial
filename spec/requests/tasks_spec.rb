require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "全タスクを返す" do
      create_list(:task, 3)
      get tasks_path
      expect(response).to have_http_status(:ok)
    end

    it "statusパラメータでフィルタリングできる" do
      pending_task = create(:task, status: :pending)
      create(:task, status: :done)
      get tasks_path, params: { status: "pending" }
      expect(response.body).to include(pending_task.title)
    end

    it "tag_idパラメータでフィルタリングできる" do
      tag = create(:tag)
      matched_task = create(:task)
      matched_task.tags << tag
      other_task = create(:task)

      get tasks_path, params: { tag_id: tag.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(matched_task.title)
      expect(response.body).not_to include(other_task.title)
    end

    it "tag_idフィルタリング時にN+1クエリが発生しない" do
      tag = create(:tag)
      tasks = create_list(:task, 3)
      tasks.each { |t| t.tags << tag }

      query_count = 0
      counter = ->(*, **) { query_count += 1 }
      ActiveSupport::Notifications.subscribed(counter, "sql.active_record") do
        get tasks_path, params: { tag_id: tag.id }
      end

      # includes(:tags) + references(:tags) により2〜3クエリ程度に収まる
      expect(query_count).to be <= 5
    end
  end
end
