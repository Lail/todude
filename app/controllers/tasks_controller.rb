class TasksController < ApplicationController

  before_filter :get_project

  def index
    @tasks = @project.tasks
    render json: @tasks
  end

  def show
    @task = @project.tasks.find(params[:id])
    render json: @task
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task = @project.tasks.find(params[:id])
    if @task.update_attributes(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end    
  end

  def destroy
    @task = @project.tasks.find(params[:id])
    @task.destroy
    render nothing: true, status: :ok
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:name, :completed, :project_id)
  end

end
