class Team < ApplicationRecord
  # this is the leader
  has_one :user
end
