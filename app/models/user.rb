class User < ApplicationRecord
  #belongs_to :scheduled_workday
  #belongs_to :attendance_record
  #belongs_to :training_enrollment
  #has_many :teams

  devise :omniauthable, :timeoutable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    #create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)

    @user = User.find_by!(email: email)
    #puts "help"
    if @user.update(uid: uid, full_name: full_name, avatar_url: avatar_url)
      @user 
    else
      let fall through to controller
    end
  end

end