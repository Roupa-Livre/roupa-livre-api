Rails.application.config.middleware.use OmniAuth::Builder do
  facebook_params = { 
    :scope => 'email, public_profile', 
    :auth_type => 'https',
    :site => 'https://graph.facebook.com/v2.11',
    :authorize_url => "https://www.facebook.com/v2.11/dialog/oauth"
  }
  if Rails.env.production?
    facebook_params[:callback_url] = 'https://api.roupalivre.com.br/omniauth/facebook/callback'
  end
  provider :facebook,      Rails.application.secrets.facebook_key, Rails.application.secrets.facebook_secret, facebook_params
end
