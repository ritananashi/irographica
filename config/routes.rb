Rails.application.routes.draw do
  unless defined?(::Rake::SprocketsTask)
    devise_for :users, controllers: { registrations: 'users/registrations' }
  end
  resources :users, only: :show do
    resources :attachments, controller: "user/attachments", only: :destroy
    get :bookmarks, on: :member
  end

  resources :products, only: %i[index show new create] do
    get :search, on: :collection
  end
  resources :reviews, only: %i[index show new create edit update destroy] do
    resources :attachments, controller: "review/attachments", only: :destroy
    resource :like, only: %i[create destroy]
    get :search, on: :collection
  end
  resources :bookmarks, only: %i[create destroy]

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
  get '/contact/', to: 'static#contact'
  root "static#home"
end
