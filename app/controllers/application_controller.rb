class ApplicationController < ActionController::Base
  #before_action :authenticate_user! gotta do smthn with this to make sure they are signed in before accessing pages maybe
  before_action :authenticate_member

  def authenticate_member
  
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    #if they try to log in while logged i think
    redirect_to(test2_path)
  end
end
