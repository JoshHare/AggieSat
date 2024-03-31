# frozen_string_literal: true

class ProjectsController < ApplicationController
  def show
    @project = Project.find_by(project_id: params[:project_id])
    @upcoming_workdays = ScheduledWorkday.where('day >= ? AND project_id = ?', Time.zone.today, @project.project_id)
    @previous_workdays = ScheduledWorkday.where('day < ? AND project_id = ?', Time.zone.today, @project.project_id)

    @status = if AttendanceRecord.where('project_id = ? AND user_id = ?', @project.project_id, current_user.uid)
                AttendanceRecord.find_by(user_id: current_user.uid, project_id: @project.project_id)
              else
                false
              end

    if current_user.uid == @project.leader_id
      @scheduled_workday = ScheduledWorkday.new
      render('show_leader')
    else
      render('show_member')
    end
  end

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.id = @project.project_id
    if @project.save
      @project.update!(project_id: @project.id)
      redirect_to(project_path(@project), notice: 'Project was successfully created.')
    else
      render(:new)
    end
  end

  def destroy
    @project = Project.find_by(project_id: params[:project_id])
    if @project.destroy
      redirect_to(projects_index_path, notice: 'Project was successfully deleted.')
    else
      redirect_to(project_path(@project), alert: 'Failed to delete the project.')
    end
  end

  def delete
    @project = Project.find(params[:project_id])
  end

  def update
    @project = Project.find_by(project_id: params[:project_id])
    if @project.update(project_params)
      redirect_to(@project, notice: 'Project was successfully updated.')
    else
      render(:edit)
    end
  end

  def add_member
    @project = Project.find_by(project_id: params[:project_id])
    @project_member = @project.project_members.build
  end

  def create_member
    @project = Project.find_by(project_id: params[:project_id])
    @project_member = @project.project_members.build(user_id: params[:user_id])

    if @project_member.save
      redirect_to(project_path(@project), notice: 'Member was successfully added to the project.')
    else
      render(:add_member)
    end
  end

  def remove_member_confirmation
    @member = User.find(params[:member_id])
    render(:remove_member)
  end

  def remove_member
    @project = Project.find_by(project_id: params[:project_id])
    @member = User.find(params[:member_id])
    @project_member = @project.project_members.find_by(user_id: @member.uid)

    if @project_member.destroy
      flash[:notice] = 'Member removed from the project successfully.'
    else
      flash[:error] = 'Failed to remove member from the project.'
    end
    redirect_to(project_path(@project))
  end

  private

  def project_params
    params.require(:project).permit(:project_name, :leader_id, :project_id, :other_attributes)
  end
end
