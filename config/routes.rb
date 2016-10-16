Rails.application.routes.draw do

  resources :payments, only: [:index] do
    get :callback, on: :collection
    get :incoming, on: :collection
    get :outgoing, on: :collection
  end

  resources :tags, only: :index

  ActiveAdmin.routes(self)

  get 'sitemap.xml', :to => 'sitemaps#index', :defaults => {:format => 'xml'}
  get 'discourse/sso', to: 'discourse_sso#sso'

  resources :ideas do
    patch :repost, on: :member
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

  get :terms, to: 'main#terms'
  get :search, to: 'main#search'
  get :about, to: 'main#about'
  get :contest, to: 'main#contest'
  get :privacy_policy, to: 'main#privacy_policy'
  root to: 'main#index'
end
