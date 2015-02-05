Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index', as: 'home'
  get 'register', to: 'users#new'

  #Sessions routes
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create' 
  get 'signout', to: 'sessions#destroy'


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
end
