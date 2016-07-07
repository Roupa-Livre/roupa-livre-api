module Overrides
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController   
    def assign_provider_attrs(user, auth_hash)
      user.assign_attributes({
        name: auth_hash.info.name, 
        nickname: auth_hash.info.nickname,
        social_image: auth_hash.info.image, 
        phone: auth_hash.info.phone
      })
    end

    def get_resource_from_auth_hash
      @identity = Identity.find_for_oauth auth_hash

      @resource = @identity.user || current_user || KindHeartedUser.new({
        email: (@identity.email || ""),
        provider: @identity.provider,
        uid: (@identity.uid || @identity.email)
      })
      @identity.user = @resource
      @identity.save!
      
      if @resource.new_record?
        @oauth_registration = true
        set_random_password
      end

      # sync user info with provider, update/generate auth token
      assign_provider_attrs(@resource, auth_hash)

      # assign any additional (whitelisted) attributes
      extra_params = whitelisted_params
      @resource.assign_attributes(extra_params) if extra_params

      @resource
    end

    # def generic_callback( provider )
    #   @identity = Identity.find_for_oauth env["omniauth.auth"]

    #   @user = @identity.user || current_user
    #   if @user.nil?
    #     new_params = { email: (@identity.email || ""), 
    #       uid: (@identity.uid || @identity.email), 
    #       social_image: @identity.image, 
    #       name: @identity.name, 
    #       phone: @identity.phone, 
    #       nickname: @identity.nickname,
    #       type: 'KindHeartedUser'
    #     }
    #     if @user.nil?
    #       @user = KindHeartedUser.create( new_params )
    #       @identity.update_attribute( :user_id, @user.id )
    #     elsif @user.register(new_params , KindHeartedUser.name)  
    #       @user = KindHeartedUser.find(@user.id)
    #       @identity.update_attribute( :user_id, @user.id )
    #     else
    #       @user = nil
    #     end
    #   end

    #   if !@user.nil?
    #     if @user.email.blank? && @identity.email
    #       @user.update_attribute( :email, @identity.email)
    #     end

    #     if (@user.name.nil? || @user.name.blank?) && @identity.name
    #       @user.update_attribute( :name, @identity.name)
    #     end

    #     if (@user.nickname.nil? || @user.nickname.blank?) && @identity.nickname
    #       @user.update_attribute( :nickname, @identity.nickname)
    #     end

    #     if (@user.phone.nil? || @user.phone.blank?) && @identity.phone
    #       @user.update_attribute( :phone, @identity.phone)
    #     end

    #     if (@user.social_image.nil? || @user.social_image.blank?) && @identity.image
    #       @user.update_attribute( :social_image, @identity.image)
    #     end

    #     if @user.persisted?
    #       @identity.update_attribute( :user_id, @user.id )
    #       # This is because we've created the user manually, and Device expects a
    #       # FormUser class (with the validations)
    #       @user = KindHeartedUser.find @user.id
    #       sign_in_and_redirect @user, event: :authentication
    #       set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    #     else
    #       session["devise.#{provider}_data"] = env["omniauth.auth"]
    #       redirect_to new_user_registration_url
    #     end
    #   else
    #     session["devise.#{provider}_data"] = env["omniauth.auth"]
    #     redirect_to new_user_registration_url
    #   end
    # end

  end
end