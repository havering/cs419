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
  post 'set_new' => 'users#set_new'
  get 'user/:id/signature' => 'users#get_signature', as: 'get_signature'
  get 'admin' => 'users#admin', as: 'admin'
  get 'reporting' => 'users#reporting', as: 'reporting'
  get 'user_awards' => 'users#user_awards'
  get 'award_by_user' => 'users#award_by_user'

  root 'home#index'
end
