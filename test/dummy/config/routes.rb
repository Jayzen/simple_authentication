Rails.application.routes.draw do
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      post :authorize, :unauthorize, :forbidden, :unforbidden
    end
    get 'search', on: :collection
  end
  root 'welcomes#index'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :portraits,            only: [:new, :create, :show, :update]
  resources :articles
  get 'articles_search', to: "welcomes#articles_search"
  get 'users_search', to: "welcomes#users_search"
end
