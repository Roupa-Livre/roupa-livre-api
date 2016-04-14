class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:name, :email, :type, :uid, :provider, :password, :password_confirmation)
      devise_parameter_sanitizer.for(:account_update).push(:name, :lat, :lng)
    end
end
