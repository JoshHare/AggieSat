# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    uid = current_user.uid
    Rails.logger.debug(uid)
    project_ids = ProjectMember.where(user_id: uid).pluck(:project_id)
    @projects = []
    project_ids.each do |project_id|
      project = Project.find_by(project_id: project_id)
      @projects << project if project.present?
    end
    @projects.each do |project|
      puts(project.project_name)
    end
  end
end
