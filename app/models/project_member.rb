# frozen_string_literal: true

class ProjectMember < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, primary_key: :uid
    belongs_to :project, foreign_key: :project_id
end
