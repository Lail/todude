class ProjectsController < ApplicationController
  def index
    @projects = ProjectDecorator.decorate_collection(Project.order('created_at ASC'))
    render :index
  end

  def show
    @project = Project.includes(:tasks).find(params[:id]).decorate
    @tasks = @project.tasks
    render :show
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      render json: @project, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end    
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    render json: @project, status: :ok
  end

  private

  def project_params
    params.require(:project).permit(:name, :color)
  end

end
