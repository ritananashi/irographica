Rails.application.routes.draw do
  unless defined?(::Rake::SprocketsTask)
    devise_for :users, controllers: {
                                      registrations: 'users/registrations',
                                      omniauth_callbacks: 'users/omniauth_callbacks',
                                      passwords: 'users/passwords'
                                    }
    devise_scope :user do
      get 'reset_request', to: 'users/passwords#reset_request'
      get 'complete_password_change', to: 'users/passwords#complete_password_change'
    end
  end
  resources :users, only: %i[show edit] do
    resources :attachments, controller: "user/attachments", only: :destroy
    patch 'update_password', on: :collection
    member do
      get :bookmarks
      get :following, :followers
    end
  end

  resources :relationships, only: %i[create destroy]

  resources :products, only: %i[index show new create] do
    collection do
      get :search
      get :autocomplete
    end
  end
  resources :reviews, only: %i[index show new create edit update destroy] do
    resources :attachments, controller: "review/attachments", only: :destroy
    resource :like, only: %i[create destroy]
    get :search, on: :collection
  end

  # 画像をCDN配信する用のルーティング
  direct :cdn_image do |model, options|
    expires_in = options.delete(:expires_in) { ActiveStorage.urls_expire_in }
    cdn_options =
      if Rails.env.production?
        {
          protocol: 'https',
          port: 443,
          host: ENV["CDN_HOST"]
        }
      else
        Rails.application.routes.default_url_options
      end

    if model.respond_to?(:signed_id)
      route_for(
        :rails_service_blob_proxy,
        model.signed_id(expires_in: expires_in),
        model.filename,
        options.merge(cdn_options)
      )
    else
      signed_blob_id = model.blob.signed_id(expires_in: expires_in)
      variation_key  = model.variation.key
      filename       = model.blob.filename

      route_for(
        :rails_blob_representation_proxy,
        signed_blob_id,
        variation_key,
        filename,
        options.merge(cdn_options)
      )
    end
  end

  resources :bookmarks, only: %i[create destroy]
  resources :notifications, only: :index

  namespace :admin do
    resources :bookmarks
    resources :brands
    resources :likes
    resources :products
    resources :reviews do
      delete :images, on: :member, action: :destroy_image
    end
    resources :users do
      delete :avatar, on: :member, action: :destroy_avatar
    end

    root to: "reviews#index"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  get '/users/:account', to: 'users#show'
  get '/users/:account/bookmarks', to: 'users#bookmarks'
  get '/users/:account/following', to: 'users#following'
  get '/users/:account/followers', to: 'users#followers'
  get '/contact/', to: 'static#contact'
  get '/privacy_policy/', to: 'static#privacy_policy'
  get '/term/', to: 'static#term'
  get '/guide/', to: 'static#guide'
  root "static#home"
end
