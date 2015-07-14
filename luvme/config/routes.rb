Rails.application.routes.draw do
  
  root 'sessions#new'

  resources :sessions, only: [:new, :create, :profile, :destroy]

  resources :viewers, only: [:profile, :preferences, :update, :destroy]

  get   '/create' => 'sessions#create' #oauth_callback
  get   '/profile' => 'viewers#profile' #show/edit
  get   '/preferences' => 'viewers#profile' #show/edit
  #updates both profile and preferences based on params, assuming we save to DB
  patch '/profile/:id' => 'viewers#profile_update', as: 'viewer_update'
  #kill session
  delete '/login' => 'viewers#destroy'

  resources :users

  # get 'users/:id/1' => 'users/1'
  # get 'users/:id/2' => 'users/2'
  # get 'users/:id/3' => 'users/3'

end
