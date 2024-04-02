# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def delete
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message(:notice, :signed_out) if signed_out && is_navigational_format?
    cookies.delete(Rails.application.config.session_options[:key])
  end

  def after_sign_out_path_for(_resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end
end
