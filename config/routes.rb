Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
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
  resources :users
  resources :queue_items, only: [:index, :create]
end
