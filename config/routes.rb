Rails.application.routes.draw do

  resources :payments, only: [] do
    get :callback, on: :collection
  end

  ActiveAdmin.routes(self)

  resources :ideas do
    resources :payments, only: :create
    resources :flags, only: :create
    resources :implementations, only: [:index, :create, :new, :show]
    resources :comments, only: :create
    resources :backer_votes, only: [:new, :create]
  end

  resources :comments, only: [] do
    resources :flags, only: :create
  end

  resources :votes, only: [] do
    get :start, on: :collection
    post :finish, on: :collection
  end

  resources :users, only: [] do
    resources :ideas, only: [:index]
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get '/.well-known/acme-challenge/EDRa5RfvqS71twzPAfvzzAcnNSi4BhaalAld5Y5SVHQ' => 'main#letsencrypt'

  get :terms, to: 'main#terms'
  get :about, to: 'main#about'
  get :privacy_policy, to: 'main#privacy_policy'
  root to: 'main#index'
end
