Rails.application.routes.draw do
  resources :ideas

  resources :users, only: [] do
    resources :ideas, only: [:index]
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  post :subscribe, to: 'main#subscribe', as: :subscribe

  get '/.well-known/acme-challenge/4LqymWrcWT6jYCSJoL9jGhNXm_70r0vZ5gZ3EdGBtGU' => 'main#letsencrypt'
  get '/.well-known/acme-challenge/JBCpA0jl5NBy9bVdvfgwZeegCFCzeI9aYxaQFd1sDGo' => 'main#letsencrypt_nowww'

  root to: 'main#index'
end
