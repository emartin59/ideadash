Rails.application.routes.draw do
  resources :ideas
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  post :subscribe, to: 'main#subscribe', as: :subscribe

  root to: 'main#index'
end
