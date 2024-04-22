# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_members, dependent: :destroy
  has_one_attached :project_photo
end
