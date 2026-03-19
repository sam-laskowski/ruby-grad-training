Rails.application.routes.draw do
  get "dashboard/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  root 'application#hello'
  resources :entries, only: [ :create, :new, :index, :destroy ]
  
  resources :users, only: [ :new, :create, :show ]

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  get 'sign_up', to: 'users#new', as: :sign_up
  post 'sign_up', to: 'users#create'

  get "game_posts", to: "game_posts#index", as: :game_posts
  get "game_posts/new", to: "game_posts#new", as: :new_game_post
  post "game_posts", to: "game_posts#create"

  resources :game_posts, only: [:destroy]

  resources :game_posts do
    resources :enrollments, only: [:create, :destroy, :update]
  end

  resource :onboarding, only: [:edit, :update]

  resource :profile, only: [:show]

  resource :confirmed_event, only: [:show]
end
