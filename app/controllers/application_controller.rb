# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # before_action :authenticate_member

  def authenticate_member; end

  rescue_from ActionController::InvalidAuthenticityToken do |_exception|
    # if they try to log in while logged i think
    redirect_to(new_user_session_path)
    # fix this later idk
  end
end
