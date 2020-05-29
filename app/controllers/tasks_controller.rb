class TasksController < ApplicationController
before_action :set_task, only: [:show, :edit, :update, :destroy]
before_action :require_login

  def index
    if params[:sort_expired]
      @tasks = current_user.tasks.order(deadline: :desc).page(params[:page]).per(10)
    elsif params[:sort_priority]
      @tasks = current_user.tasks.order(priority: :asc).page(params[:page]).per(10)
    else
      @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(10)
    end

    if params[:search].present?
      if params[:title].present? && params[:status].present?
        @tasks = Task.title_search(params[:title]).status_search(params[:status]).page(params[:page]).per(10)
      elsif params[:title].present?
        @tasks = Task.title_search(params[:title]).page(params[:page]).per(10)
      elsif params[:status].present?
        @tasks = Task.status_search(params[:status]).page(params[:page]).per(10)
      end
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
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
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
