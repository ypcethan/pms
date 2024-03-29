class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :require_user
  before_action :require_the_same_user, only: %i[edit update destroy]

  ORDER_DIRECTIONS = %w[desc asc]
  FILEDS_TO_SORT_BY = %w[created_at due_date priority]
  PROJECT_STATUS = %w[todo doing done]

  def index
    set_project_query_params
    @projects = if @selected_status == 'all'
                  current_user.projects.all
                else
                  current_user.projects.where(status: @selected_status)
                end

    if params[:label_names] && params[:label_names] != ''
      @projects = @projects.joins(:labels).where('labels.name IN (?)', get_labels)
    end

    @projects = if @search_terms == ''
                  @projects.order(project_sort_by_params).page(params[:page])
                else
                  @projects.search(@search_terms).order(project_sort_by_params).page(params[:page])
                end
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    @project.labels = processed_labels

    if @project.save
      flash[:notice] = t('project.create.success')
      redirect_to user_project_path(current_user, @project)
    else
      flash.now[:alert] = t('project.create.failure')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @project.update(project_params)
      @project.labels.delete_all
      @project.labels << processed_labels
      flash[:notice] = t('project.update.success')
      redirect_to user_project_path(current_user, @project)
    else
      flash.now[:alert] = t('project.update.failure')
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:notice] = t('project.delete.success')
    redirect_to user_projects_path(current_user)
  end

  private

  def set_project_query_params
    @selected_order_direction = ORDER_DIRECTIONS.include?(params[:order_direction]) ? params[:order_direction] : 'desc'
    @selected_sort_by = FILEDS_TO_SORT_BY.include?(params[:sort_by]) ? params[:sort_by] : 'created_at'
    @selected_status = PROJECT_STATUS.include?(params[:status]) ? params[:status] : 'all'
    @search_terms = params[:search] || ''
    @label_names = params[:label_names] || ''
  end

  def project_sort_by_params
    Hash[@selected_sort_by, @selected_order_direction]
  end

  def get_labels
    params[:label_names].split(',').map(&:strip)
  end

  def processed_labels
    params[:label_names].split(',').map do |label|
      Label.find_or_initialize_by(name: label.strip)
    end
  end

  def set_project
    @project = Project.friendly.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :content,
                                    :due_date, :start_date,
                                    :status, :priority)
  end

  def require_the_same_user
    if current_user != @project.user
      flash[:alert] = t('project.access.unauthorized')
      redirect_to projects_path
    end
  end
end
