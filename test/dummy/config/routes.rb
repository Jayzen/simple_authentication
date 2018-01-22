Rails.application.routes.draw do
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      post :authorize, :unauthorize, :forbidden, :unforbidden, :avatar_create, :avatar_update
      get :avatar_new
    end
  end
  root 'welcomes#index'
  resources :account_activations, only: [:edit]
end
