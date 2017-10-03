Rails.application.routes.draw do
  resources :chat_messages, except: [:new, :edit]
  resources :chats, except: [:new, :edit] do
    collection do
      get 'active_by_user/:user_id', to: "chats#active_by_user"
    end
    member do
      post 'block'
    end
  end
  resources :apparel_ratings, except: [:new, :edit]
  resources :property_groups, only: [:index]
  resources :apparel_tags, except: [:new, :edit]
  resources :apparel_images, except: [:new, :edit]
  resources :apparels, except: [:new, :edit] do
    collection do
      get 'owned'
    end
    member do
      post 'report'

      get '/remove_reported/:token', to: 'apparels#remove_reported', as: 'remove_reported'
    end
  end
  post 'users/update_image', to: "users#update_image"
  post 'users/register_device', to: "users#register_device"
  post 'users/unregister_device', to: "users#unregister_device"
  post 'users/agreed_to_terms', to: "users#agreed_to_terms"
  get 'users/heat_users', to: "users#heat_users"
  get 'users/heatmap', to: "users#heatmap"

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'overrides/registrations',
    token_validations: 'overrides/token_validations',
    omniauth_callbacks: "overrides/omniauth_callbacks"
  }

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq-dashboard'
end
