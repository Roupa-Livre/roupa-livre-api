module Overrides
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
    def instagram
      generic_callback( 'instagram' )
    end

    def facebook
      generic_callback( 'facebook' )
    end

    def twitter
      generic_callback( 'twitter' )
    end

    def google_oauth2
      generic_callback( 'google_oauth2' )
    end

    def generic_callback( provider )
      @identity = Identity.find_for_oauth env["omniauth.auth"]

      @user = @identity.user || current_user
      if @user.nil?
        new_params = { email: (@identity.email || ""), 
          uid: (@identity.uid || @identity.email), 
          social_image: @identity.image, 
          name: @identity.name, 
          phone: @identity.phone, 
          nickname: @identity.nickname
        }
        if @user.nil?
          @user = KindHeartedUser.create( new_params )
          @identity.update_attribute( :user_id, @user.id )
        elsif @user.register(new_params , KindHeartedUser.name)  
          @user = KindHeartedUser.find(@user.id)
          @identity.update_attribute( :user_id, @user.id )
        else
          @user = nil
        end
      end

      if !@user.nil?
        if @user.email.blank? && @identity.email
          @user.update_attribute( :email, @identity.email)
        end

        if (@user.name.nil? || @user.name.blank?) && @identity.name
          @user.update_attribute( :name, @identity.name)
        end

        if (@user.nickname.nil? || @user.nickname.blank?) && @identity.nickname
          @user.update_attribute( :nickname, @identity.nickname)
        end

        if (@user.phone.nil? || @user.phone.blank?) && @identity.phone
          @user.update_attribute( :phone, @identity.phone)
        end

        if (@user.social_image.nil? || @user.social_image.blank?) && @identity.image
          @user.update_attribute( :social_image, @identity.image)
        end

        if @user.persisted?
          @identity.update_attribute( :user_id, @user.id )
          # This is because we've created the user manually, and Device expects a
          # FormUser class (with the validations)
          @user = KindHeartedUser.find @user.id
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      else
        session["devise.#{provider}_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

  end
end