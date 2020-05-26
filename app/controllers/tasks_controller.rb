class TasksController < ApplicationController
before_action :set_task, only: [:show, :edit, :update, :destroy]


  def index
    if params[:sort_expired]
      @tasks = Task.all.order(deadline: :desc)
    else
      @tasks = Task.all.order(created_at: :desc)
    end

    if params[:search].present?
      if params[:title].present? && params[:status].present?
        @tasks = Task.title_search(params[:title]).status_search(params[:status])
      elsif params[:title].present?
        @tasks = Task.title_search(params[:title])
      elsif params[:status].present?
        @tasks = Task.status_search(params[:status])
      end
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "タスクを作成しました！"
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "タスクを編集しました！"
      redirect_to tasks_path
    else
      render edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "タスクを削除しました！"
    redirect_to tasks_path
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
