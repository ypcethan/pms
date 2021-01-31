class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:notice] = 'Project has been created.'
      redirect_to project_path(@project)
    else
      flash[:alert] = 'Project has not been created.'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:notice] = 'Project has been updated.'
      redirect_to project_path(@project)
    else
      flash[:alert] = 'Project has not been updated.'
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:notice] = 'Project has been deleted.'
    redirect_to projects_path
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :content)
  end
end
