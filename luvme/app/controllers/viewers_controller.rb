class ViewersController < ApplicationController
	# before_action :authorize
	
	# def new
	# #API call to get relevant veiwer data
	# 	headers = {
	# 		:Authorization => "OAuth #{session[:access_token]}"
	# 	}
	# 	url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums,picture{url}"
	# 	@viewer = JSON.parse( RestClient.get(url, headers) )
		
	# #new_viewer object
	# 	new_viewer = Viewer.new({
	# 		fname: @viewer['first_name'],
	# 		gender: @viewer['gender'],
	# 		location: @viewer['location']
	# 		profile_album_url: parse_profile_pics(@viewer)
	# 	})
	# #saving new_viewer to DB
	# 	if new_viewer.save
	# 		render :profile
	# 	else
	# 		redirect_to "/users/#{session[:app_id]}/viewers/new"
	# 	end
	# #need to build redirect if gender doesn't match target gender
	# end

	# def preferences
	# 	render :preferences
	# end

	# private

	# def parse_profile_pics(response)
	# 	albums = response['albums']['data']
	# 	albums.each do |album|
	# 		if album['name'] == 'Profile Pictures'
	# 			pp = album
	# 		end
	# 		pp
	# 	end
	# end


	# finds the first album which may not always be the profile album >> url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums.limit(1){photos.limit(10){name,link}}"

end#VC