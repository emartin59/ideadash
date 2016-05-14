Rails.application.routes.draw do
  resources :ideas
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  post :subscribe, to: 'main#subscribe', as: :subscribe

  get '/.well-known/acme-challenge/UbCdFEh8G_VlbCXa9Ma-jrowj-gsvUdnin2zLz9LqEc' => 'main#letsencrypt'

  root to: 'main#index'
end
