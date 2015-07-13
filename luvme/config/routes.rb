Rails.application.routes.draw do
  
  root 'sessions#new'

  resources :sessions, only: [:new, :create, :profile, :destroy]

  get   '/create' => 'sessions#create'
  get   '/profile' => 'sessions#profile'
  delete '/login' => 'sessions#destroy'

  resources :users

  # get 'users/:id/1' => 'users/1'
  # get 'users/:id/2' => 'users/2'
  # get 'users/:id/3' => 'users/3'

end
