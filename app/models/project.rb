# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_members, dependent: :destroy
end
