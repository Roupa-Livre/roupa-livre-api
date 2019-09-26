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
  resources :global_tags, only: [:show]
  resources :apparel_tags, except: [:new, :edit]
  resources :apparel_images, except: [:new, :edit]
  resources :apparels, except: [:new, :edit] do
    collection do
      get 'owned'
      get 'matched'
    end
    member do
      post 'report'

      get '/remove_reported/:token', to: 'apparels#remove_reported', as: 'remove_reported'
    end
  end

  get 'apparels/apparels_by_user/:user_id', to: "apparels#apparels_by_user"
  get 'apparels/apparels_by_tag/:tag_id', to: "apparels#apparels_by_tag"

  post 'users/update_image', to: "users#update_image"
  post 'users/register_device', to: "users#register_device"
  post 'users/unregister_device', to: "users#unregister_device"
  post 'users/agreed_to_terms', to: "users#agreed_to_terms"
  

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'overrides/registrations',
    omniauth_callbacks: "overrides/omniauth_callbacks"
  }

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq-dashboard'

  namespace :web do
    # devise_for :admins
    devise_for :users

    root to: "main#index"
    get 'logout', to: "main#logout"

    get 'users/heat_users', to: "users#heat_users"
    get 'users/heatmap', to: "users#heatmap"
    get 'users/heatcount', to: "users#heatcount"

    resources :global_tags
  end
end
