class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy update_status]

  def index
    @tasks = Task.includes(:tags).by_due_date

    if params[:status].present?
      @tasks = @tasks.where(status: params[:status]) if Task.statuses.key?(params[:status])
    end

    if params[:tag_id].present?
      tag_id = params[:tag_id].to_i
      @tasks = @tasks.joins(:tags).where(tags: { id: tag_id }) if tag_id > 0 && Tag.exists?(tag_id)
    end

    @tags = Tag.order(:name)
  end

  def show
  end

  def new
    @task = Task.new
    @tags = Tag.order(:name)
  end

  def edit
    @tags = Tag.order(:name)
  end

  def create
    @task = Task.new(task_params)
    @task.tag_ids = params[:task][:tag_ids].reject(&:blank?) if params[:task][:tag_ids]

    if @task.save
      redirect_to tasks_path, notice: "タスクを作成しました。"
    else
      @tags = Tag.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @task.tag_ids = params[:task][:tag_ids].reject(&:blank?) if params[:task][:tag_ids]

    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました。"
    else
      @tags = Tag.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました。"
  end

  def update_status
    @task.update!(status: params[:status])
    redirect_to tasks_path, notice: "ステータスを更新しました。"
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
