class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if ENV['RACK_ENV'] == "production"
    APP_ID = ENV['FACEBOOK_APP_ID']
    APP_SECRET = ENV['FACEBOOK_APP_SECRET']
    ROOT = "http://desolate-hamlet-2924.herokuapp.com"
  else
    APP_ID = ENV['FACEBOOK_test_ID']
    APP_SECRET = ENV['FACEBOOK_test_SECRET']
    ROOT = "http://bcc10ed3.ngrok.io"
  end

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authorize
  	redirect_to '/' unless current_user
  end



end
