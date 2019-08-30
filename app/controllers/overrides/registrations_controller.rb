module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    
    def create
      super do |resource|
        # cria usando device id
        if sign_up_params[:provider].present?
          @resource.identities.create({ uid: @resource.uid, provider: @resource.provider })
        end
      end 
    end
  end
end