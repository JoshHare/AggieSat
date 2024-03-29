# frozen_string_literal: true

class ProjectMember < ApplicationRecord
  belongs_to :project
  def self.count_for_project(project_id)
    where(project_id: project_id).count
  end
end
