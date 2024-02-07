class Users::SessionsController < Devise::SessionsController #not used rn
  def after_sign_out_path_for(_resource_or_scope)
    new_admin_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    test2_path
  end
end
