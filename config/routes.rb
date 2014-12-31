Rails.application.routes.draw do
  resources :carts

  root 'store#index', as: 'store'
  get 'store/index'
  resources :products
end
