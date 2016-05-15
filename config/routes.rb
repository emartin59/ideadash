Rails.application.routes.draw do
  resources :ideas

  resources :users, only: [] do
    resources :ideas, only: [:index]
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  post :subscribe, to: 'main#subscribe', as: :subscribe

  get '/.well-known/acme-challenge/EDRa5RfvqS71twzPAfvzzAcnNSi4BhaalAld5Y5SVHQ' => 'main#letsencrypt'

  root to: 'main#index'
end
