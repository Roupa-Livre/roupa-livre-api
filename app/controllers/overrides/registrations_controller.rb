module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    
    before_filter :configure_sign_up_params, only: [:create]
    before_filter :configure_account_update_params, only: [:update]

    def create
      super do |resource|
        # cria usando device id
        if sign_up_params[:provider].present?
          @resource.identities.create({ uid: @resource.uid, provider: @resource.provider })
        end
      end 
    end
    
    def update_resource(resource, params)
      if resource.encrypted_password.blank? # || params[:password].blank?
        resource.email = params[:email] if params[:email]
        if !params[:password].blank? && params[:password] == params[:password_confirmation]
          logger.info "Updating password"
          resource.password = params[:password]
          resource.save
        end
        if resource.valid?
          resource.update_without_password(params)
        end
      else
        resource.update_with_password(params)
      end
    end

    private

      def configure_sign_up_params
        devise_parameter_sanitizer.for(:sign_up).push(:name, :email, :type, :uid, :provider, :password, :password_confirmation)
      end

      def configure_account_update_params
        devise_parameter_sanitizer.for(:account_update).push(:name, :lat, :lng, :name, :phone, :email, :address)
      end
  end
end