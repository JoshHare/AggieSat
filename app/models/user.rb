# frozen_string_literal: true

class User < ApplicationRecord
  # belongs_to :scheduled_workday
  # belongs_to :attendance_record
  # belongs_to :training_enrollment
  # has_many :teams

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  attr_accessor :uid, :full_name, :avatar_url

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    # return nil unless email =~ /@mybusiness.com\z/
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end
end
