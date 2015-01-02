Rails.application.routes.draw do
  resources :orders

  resources :line_items

  resources :carts

  root 'store#index', as: 'store'
  get 'store/index'
  resources :products
end
