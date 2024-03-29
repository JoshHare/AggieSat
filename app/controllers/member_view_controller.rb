# frozen_string_literal: true

# app/controllers/members_controller.rb

class MemberViewController < ApplicationController
  before_action :set_member, only: [:show]

  def show
    @projects = Project.where(project_name: params[:project_name])
    @scheduled_workdays = ScheduledWorkday.where(day: params[:day])
  end

  private

  def set_member
    @member = User.find(current_user.id)
  end
end
