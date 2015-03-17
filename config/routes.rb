Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index', as: 'home'
  get 'register', to: 'users#new'

  #Sessions routes
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create' 
  get 'signout', to: 'sessions#destroy'

  resources :charges, only: [:create]


  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  resources :videos, only: [:show] do
    collection do
      post :search, to: 'videos#search'
    end
    resources :reviews
  end

  resources :categories, only: [:show]

  resources :users, only: [:new, :show, :create] do
    resources :followings, only: [:index]
  end
  #This is called Shallow Nesting
  resources :followings, only: [:create, :destroy]

  resources :queue_items, only: [:index, :create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  resources :forgot_passwords, only: [:create]
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:create] 
  get 'invite_friend', to: 'invitations#new' 
  get 'invitation/:token', to: 'users#invited_user', as: 'invited_user'
  mount StripeEvent::Engine, at: '/stripe_events'
end
