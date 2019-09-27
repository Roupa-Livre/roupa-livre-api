class Web::ApplicationController < ApplicationController
  layout "admin"
  # respond_to :html, :json

  def authenticate_admin!
    authenticate_web_user!
    # puts "type:" + current_web_user.type
    if current_web_user.type != Admin.name
      sign_out current_web_user
      return redirect_to new_web_user_session_path, status: 401
    end
  end
end
