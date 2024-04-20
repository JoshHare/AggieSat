# frozen_string_literal: true

class ProjectsController < ApplicationController
  def show
    
    @project = Project.find_by(project_id: params[:project_id])
    @upcoming_workdays = ScheduledWorkday.where('day >= ? AND project_id = ?', Time.zone.today, @project.project_id)
    @previous_workdays = ScheduledWorkday.where('day < ? AND project_id = ?', Time.zone.today, @project.project_id)
    @pending_members = AttendanceRecord.where('checkin >= ? AND project_id = ?', Time.zone.today, @project.project_id)
    @approval_status = AttendanceRecord.where('user_id = ? AND checkin >= ? AND project_id = ?', current_user.uid, Time.zone.today,
                                              @project.project_id
    )
    @previous_status = AttendanceRecord.where('user_id = ? AND checkin < ? AND project_id = ?', current_user.uid, Time.zone.today,
                                              @project.project_id
    )

    @status = if AttendanceRecord.where('project_id = ? AND user_id = ?', @project.project_id, current_user.uid)
                AttendanceRecord.find_by(user_id: current_user.uid, project_id: @project.project_id)
              else
                false
              end

    if current_user.uid == @project.leader_id || current_user.role == "Admin"
      @scheduled_workday = ScheduledWorkday.new
      render('show_leader')
    else
      render('show_member')
    end
  end

  def index
    @projects = Project.all.order(:project_id)
  end

  # rubocop:disable Lint/NumberConversion
  def new
    @project = Project.new
    @project.project_id = Project.maximum(:project_id).to_i + 1
  end
  # rubocop:enable Lint/NumberConversion

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
    @member = User.find_by(uid: params[:member_id])
    render(:remove_member)
  end

  def remove_member
    @project = Project.find_by(project_id: params[:project_id])
    @member = User.find_by(uid: params[:member_id])
    @project_member = @project.project_members.find_by(user_id: @member.uid)

    if @project_member.destroy
      flash[:notice] = 'Member removed from the project successfully.'
    else
      flash[:error] = 'Failed to remove member from the project.'
    end
    redirect_to(project_path(@project))
  end

  def create_record
    workday = ScheduledWorkday.find(params[:workday_id])
    @project = Project.find(params[:project_id])
    if AttendanceRecord.create!(user_id: current_user.uid, schedule_id: workday.id, project_id: workday.project_id,
                                checkin: Time.current.in_time_zone('Central Time (US & Canada)'), approval_status: false
    )

      redirect_to(project_path(@project), notice: 'Checked in successfully.')
    else
      render(:index)
    end
  end

  def accept_member
    checkin = AttendanceRecord.where(user_id: params[:user_id], schedule_id: params[:schedule_id])
    @project = Project.find(params[:project_id])
    if checkin&.update!(approval_status: true)
      redirect_to(project_path(@project), notice: 'Accepted Check in.')
    else
      render(:index)
    end
  end

  def reject_member
    reject_checkin = AttendanceRecord.where(user_id: params[:user_id], schedule_id: params[:schedule_id]).first
    @project = Project.find(params[:project_id])
    if reject_checkin.destroy!
      redirect_to(project_path(@project), notice: 'Rejected Check in.')
    else
      render(:index)
    end
  end

  def edit
    @project = Project.find_by(project_id: params[:project_id])
  end

  def update
    @project = Project.find_by(project_id: params[:project_id])
    if @project.update(project_params)
      redirect_to(project_path(@project), notice: 'Project was successfully updated.')
    else
      render(:edit)
    end
  end

  def csv 
    project = Project.find(params[:project_id])
    scheduled_workday = ScheduledWorkday.find(params[:schedule_id])
    respond_to do |format|
      format.html
      format.csv { send_data AttendanceRecord.to_csv(%w(approval_status), %w(full_name), project.project_id, scheduled_workday.id), filename: "workday#{project.project_name}-day#{scheduled_workday.day}-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"}
    end
  end 

  private

  def project_params
    params.require(:project).permit(:project_name, :leader_id, :project_id, :other_attributes)
  end
end
