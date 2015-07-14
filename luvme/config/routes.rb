Rails.application.routes.draw do
  
  root  'sessions#new'
  get   '/create'   => 'sessions#create' #oauth_callback
  get   '/logout'   => 'sessions#destroy'

  resources :users, except: [:index, :create] 
  # do
  #   resources :viewers, except: [:index, :show, :create]
  # end

end
