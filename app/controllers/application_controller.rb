class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  #before_action :authenticate_member

  def authenticate_member
  
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    #if they try to log in while logged i think
    #redirect_to(test_path)
    flash[:success] = "Error. Already logged in. Please logout first."
    #fix this later idk
  end
end
