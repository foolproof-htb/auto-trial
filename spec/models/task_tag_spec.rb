require 'rails_helper'

RSpec.describe TaskTag, type: :model do
  describe 'バリデーション' do
    it '有効なtask_idとtag_idがある場合は有効' do
      task_tag = create(:task_tag)
      expect(task_tag).to be_valid
    end

    it 'task_idがない場合は無効' do
      task_tag = build(:task_tag, task: nil)
      expect(task_tag).not_to be_valid
      expect(task_tag.errors[:task_id]).to include("can't be blank")
    end

    it 'tag_idがない場合は無効' do
      task_tag = build(:task_tag, tag: nil)
      expect(task_tag).not_to be_valid
      expect(task_tag.errors[:tag_id]).to include("can't be blank")
    end

    it '同じtask_idとtag_idの組み合わせは無効' do
      task = create(:task)
      tag = create(:tag)
      create(:task_tag, task: task, tag: tag)
      duplicate = build(:task_tag, task: task, tag: tag)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:task_id]).to include('has already been taken')
    end

    it '同じtask_idでも異なるtag_idなら有効' do
      task = create(:task)
      create(:task_tag, task: task, tag: create(:tag))
      another = build(:task_tag, task: task, tag: create(:tag))
      expect(another).to be_valid
    end
  end
end
