Rails.application.routes.draw do
  
  root  'sessions#new'
  get   '/create'   => 'sessions#create' #oauth_callback
  get   '/logout'   => 'sessions#destroy'

  resources :users, only: [:new, :show, :update]
  get '/users/:id/photos' => 'users#photos'
  get '/users/loading'    => 'users#loading'
  get '/users/:id/share'  => 'users#share'

end
