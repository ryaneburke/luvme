Rails.application.routes.draw do
  
  root  'sessions#new'
  get   '/create'   => 'sessions#create' #oauth_callback
  get   '/logout'   => 'sessions#destroy'

  get		'/users/new'					=> 'users#new' #type agnostic, renders :profile
  get 	'/users/:id/photos' 	=> 'users#photos' #admin only
  get 	'/users/:id/prefs'		=> 'users#prefs' #type agnostic
  get 	'/users/loading'    	=> 'users#loading' #type agnostic
  get 	'/users/:referrer_id/share'  	=> 'users#share' #admin only, cta to share with viewers
  
  get 	'/browse'							=> 'users#browse' #type agnostic, primarily 
  get   '/browse.json'        => 'users#gset_images' #pulling photos for browse
  get		'/users/:id/convert'	=> 'users#convert' #viewer only, cta prompt to viewers to make their own
  patch '/users/:id/switch_types'=> 'users#switch_types' #viewer only, viewer to admin switch

  get 	'/users/:id/profile'	=> 'users#profile' #admin only, if an admin wants to update their profile later
  patch	'/users/:id'					=> 'users#update' #type agnostic, updates user model, redirects to profile
  get   '/:referrer_id'       => 'sessions#new'

  #########
  get '/demo/prefs'    => 'demo#prefs'
  get '/demo/loading'  => 'demo#loading'
  get '/demo/browse'   => 'demo#browse' 
  get '/demo/convert'  => 'demo#convert'
  get '/demo/share'    => 'demo#share'

end
