# frozen_string_literal: true

class Project < ApplicationRecord
    belongs_to :leader, class_name: "User", foreign_key: :leader_id, primary_key: :uid
    has_many :project_members, foreign_key: :project_id
    has_many :members, through: :project_members, source: :user

end
