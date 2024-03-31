# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_members # rubocop:disable Rails/HasManyOrHasOneDependent
end
