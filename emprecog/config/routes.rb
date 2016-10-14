Rails.application.routes.draw do
  resources :awards
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  get 'reset_password' => 'users#reset_password'
  post 'reset_password' => 'users#newpassword'

  root 'home#index'
end
