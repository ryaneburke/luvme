class SessionsController < ApplicationController

	APP_ID = ENV['FACEBOOK_APP_ID']
	APP_SECRET = ENV['FACEBOOK_APP_SECRET']

	#NEED TO ADD ID & SECRET BEFORE TESTING

	# session[:user_id]
	# session[:app_id]
	# session[:viewer_id]

	#viewer has an app_id, needs a viewer_id
	#newbie needs a user_id and app_id
	#user has a user_id and an app_id

	def new
	# #viewer who is already authenticated
	# 	if session[:app_id] && session[:viewer_id]
	# 		redirect_to "/users/#{session[:app_id]}"
	# #user who is already authenticated
	# 	elsif session[:app_id] == session[:user_id]
	# 		redirect_to "/users/#{session[:app_id]}"
	# #newbie with reference link - viewer who needs to be authenticated
	# 	elsif session[:app_id] && !session[:user_id]
	#   	@auth_url = oauth_url_generator
	#   	render :new
	# #newbie who is coming without reference link
	#   else
	  	@auth_url = oauth_url_generator
	  	render :new
	  # end
	end

	def create
	#need:: check to see if status code is a redirect, if yes, proceed, if not, redirect away
		code = params[:code]
  	state = params[:state]
  	if session[:auth_state] == state
  		fb_response = get_access_token(code)
  		session[:access_token] = JSON.parse(fb_response)["access_token"]
  		# if session[:app_id]
  			redirect_to '/users/#{session[:app_id}/create'
  		# else
  		# 	redirect_to '/users/new'
  		# end
  	else
  		"we've been tampered with"
  #need:: do a rerequest to follow up on denied or modified scope permissions
  	end
	end

	def destroy
		session[:user_id] = nil
		session[:viewer_id] = nil
		redirect_to '/'
	end

	private

	def oauth_url_generator
		base_url ='https://www.facebook.com/dialog/oauth'
  	redirect_uri = 'http://7bc3eef2.ngrok.io/create'
  	state = SecureRandom.urlsafe_base64
  	session[:auth_state] = state
  	client_id = APP_ID
  	display = "popup"
  	response_type = "code"
  	redirect_uri = redirect_uri
  	state = state
  	scope = "public_profile, user_photos"
  	oauth_url = "#{base_url}?client_id=#{client_id}&display=#{display}&response_type=#{response_type}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
	end

	def get_access_token(code)
		url = "https://graph.facebook.com/v2.3/oauth/access_token?"
		data = {
			client_id: APP_ID,
			client_secret: APP_SECRET,
			code: code,
			redirect_uri: 'http://7bc3eef2.ngrok.io/create'}
		headers = {
			:Accept => :json}
		RestClient.post(url, data, headers)
	end


end#SC