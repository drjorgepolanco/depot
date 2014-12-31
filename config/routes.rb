Rails.application.routes.draw do
  root 'store#index', as: 'store'
  get 'store/index'
  resources :products
end
