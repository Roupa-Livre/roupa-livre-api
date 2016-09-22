Rails.application.routes.draw do
  resources :chat_messages, except: [:new, :edit]
  resources :chats, except: [:new, :edit] do
    collection do
      get 'active_by_user/:user_id', to: "chats#active_by_user"
    end
  end
  resources :apparel_ratings, except: [:new, :edit]
  resources :apparel_tags, except: [:new, :edit]
  resources :apparel_images, except: [:new, :edit]
  resources :apparels, except: [:new, :edit] do
    collection do
      get 'owned'
    end
  end
  post 'users/update_image', to: "users#update_image"
  post 'users/register_device', to: "users#register_device"

  mount_devise_token_auth_for 'User', at: 'auth', controllers: { 
    registrations: 'overrides/registrations', 
    token_validations: 'overrides/token_validations', 
    omniauth_callbacks: "overrides/omniauth_callbacks" 
  }
  end
