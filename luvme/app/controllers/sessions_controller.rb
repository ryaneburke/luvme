class SessionsController < ApplicationController

	APP_ID = ENV['FACEBOOK_APP_ID']
	APP_SECRET = ENV['FACEBOOK_APP_SECRET']

	def new
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
  	@auth_url = "#{base_url}?client_id=#{client_id}&display=#{display}&response_type=#{response_type}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
  	render :new
	end

	def create
		code = params[:code]
  	state = params[:state]
  	if session[:auth_state] == state
  		"we're in!"
  		url = "https://graph.facebook.com/v2.3/oauth/access_token?"
  		data = {
  			client_id: CLIENT_ID,
  			client_secret: CLIENT_SECRET,
  			code: code,
  			redirect_uri: 'http://7bc3eef2.ngrok.io/create'
  		}
  		headers = {
  			:Accept => :json
  		}
  		fb_response = RestClient.post(url, data, headers)
  		binding.pry
  		session[:access_token] = JSON.parse(github_response)["access_token"]
  		redirect '/profile'
  	else
  		"we've been tampered with"
  	end
	end

end#SC