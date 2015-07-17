class SessionsController < ApplicationController

	# APP_ID = Rails.application.secrets.facebook_app_id
	# APP_SECRET = Rails.application.secrets.facebook_app_secret

	if ENV['RACK_ENV'] == "production"
		APP_ID = ENV['FACEBOOK_test_ID']
		APP_SECRET = ENV['FACEBOOK_test_SECRET']
		ROOT = "http://desolate-hamlet-2924.herokuapp.com/"
	else
		APP_ID = ENV['FACEBOOK_test_ID']
		APP_SECRET = ENV['FACEBOOK_test_SECRET']
		ROOT = "http://a491c25e.io"
	end

	def new
		session[:referrer_id] = params[:referrer_id]
  	@auth_url = oauth_url_generator
  	render :new
	end

	def create
	#need:: check to see if request is coming from facebook API, if yes, proceed, if not, redirect away
		begin

			code = params[:code]
	  	state = params[:state]

	  	if session[:auth_state] == state

	  		fb_response = get_access_token(code)
	  		session[:access_token] = JSON.parse(fb_response)["access_token"]
	  		redirect_to '/users/new'
	  	else
	  		redirect_to '/'
	  #need:: do a rerequest to follow up on denied or modified scope permissions
	  	end
	  rescue => e
	  	puts e
	  end
			redirect_to '/'
	end

	def destroy
		session[:user_id] = nil
		session[:viewer_id] = nil
		redirect_to '/'
	end

	private

	def oauth_url_generator
		base_url ='https://www.facebook.com/dialog/oauth'
  	redirect_uri = "#{ROOT}/create"
  	state = SecureRandom.urlsafe_base64
  	session[:auth_state] = state
  	client_id = APP_ID
  	display = "popup"
  	response_type = "code"
  	scope = "public_profile, user_photos"
  	oauth_url = "#{base_url}?client_id=#{client_id}&display=#{display}&response_type=#{response_type}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
	end

	def get_access_token(code)
		url = "https://graph.facebook.com/v2.3/oauth/access_token?"
		data = {
			client_id: APP_ID,
			client_secret: APP_SECRET,
			code: code,
			redirect_uri: "#{ROOT}/create"}
		headers = {
			:Accept => :json}
		RestClient.post(url, data, headers)
	end


end#SC