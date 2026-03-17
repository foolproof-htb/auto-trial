require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "returns http success" do
      get tasks_path
      expect(response).to have_http_status(:success)
    end

    context "with valid status param" do
      it "filters tasks by status" do
        pending_task = create(:task, status: :pending)
        done_task = create(:task, status: :done)

        get tasks_path, params: { status: "pending" }

        expect(response.body).to include(pending_task.title)
        expect(response.body).not_to include(done_task.title)
      end
    end

    context "with invalid status param" do
      it "ignores the invalid status and returns all tasks" do
        task = create(:task, status: :pending)

        get tasks_path, params: { status: "invalid_status" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(task.title)
      end
    end

    context "with valid tag_id param" do
      it "filters tasks by tag" do
        tag = create(:tag)
        tagged_task = create(:task)
        tagged_task.tags << tag
        untagged_task = create(:task)

        get tasks_path, params: { tag_id: tag.id }

        expect(response.body).to include(tagged_task.title)
        expect(response.body).not_to include(untagged_task.title)
      end
    end

    context "with non-existent tag_id param" do
      it "ignores the tag_id and returns all tasks" do
        task = create(:task)

        get tasks_path, params: { tag_id: 99999 }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(task.title)
      end
    end

    context "with non-integer tag_id param" do
      it "ignores the invalid tag_id and returns all tasks" do
        task = create(:task)

        get tasks_path, params: { tag_id: "invalid" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(task.title)
      end
    end

    context "with zero tag_id param" do
      it "ignores zero tag_id and returns all tasks" do
        task = create(:task)

        get tasks_path, params: { tag_id: 0 }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(task.title)
      end
    end

    context "with negative tag_id param" do
      it "ignores negative tag_id and returns all tasks" do
        task = create(:task)

        get tasks_path, params: { tag_id: -1 }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(task.title)
      end
    end
  end
end
