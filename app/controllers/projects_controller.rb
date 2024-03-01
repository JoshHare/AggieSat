class ProjectsController < ApplicationController
  def show
    @project = Project.find_by(project_id: params[:project_id])
    @upcoming_workdays = ScheduledWorkday.where('day >= ? AND project_id = ?', Date.today, @project.project_id)
    @previous_workdays = ScheduledWorkday.where('day < ? AND project_id = ?', Date.today, @project.project_id)

    if AttendanceRecord.where('project_id = ? AND user_id = ?', @project.project_id, current_user.uid)
      @status = AttendanceRecord.find_by(user_id: current_user.uid, project_id: @project.project_id)
    else
      @status = false
    end

    if current_user.uid == @project.leader_id
      @scheduled_workday = ScheduledWorkday.new
      render 'show_leader'
    else
      render 'show_member'
    end
  end
end
