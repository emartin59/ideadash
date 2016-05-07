Rails.application.routes.draw do
  root to: 'main#index'

  post :subscribe, to: 'main#subscribe', as: :subscribe
end
