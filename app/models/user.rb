class User < ApplicationRecord
  #belongs_to :scheduled_workday
  #belongs_to :attendance_record
  #belongs_to :training_enrollment
  #has_many :teams

  validates :email, presence: true
  validates :full_name, presence: true
  validates :uid, presence: true
  validate :valid_params
  #validates :avatar_url, presence: true

  devise :omniauthable, :timeoutable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    #create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)

    @user = User.find_by!(email: email)
    #puts "help"
    if @user.update(uid: uid, full_name: full_name, avatar_url: avatar_url)
      @user 
    else
      #let fall through to controller
    end

  end

  def valid_params
    errors.add(:email, "email must not be empty and valid") unless email.include?"@"
    errors.add(:full_name, "full name must not be empty") unless full_name != ''
    errors.add(:uid, "uid must not be empty") unless uid != ''
  end 
end
