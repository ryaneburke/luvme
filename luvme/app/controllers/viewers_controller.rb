class ViewersController < ApplicationController
	
	def profile #show/edit route
		headers = {
			:Authorization => "OAuth #{session[:access_token]}"
		}
		url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums,picture{url}"
		@user = JSON.parse( RestClient.get(url, headers) )
		profile_pics = parse_profile_pics(@user)
		session[:profile_album_id] = profile_pics['id']
		#going to use this [:profile_album_id] at a later date to get all of the profile pictures if viewer converts to user

		#need to do something with name, location, gender >> send to DB, Users table, type: Viewer?

		#need to build redirect if gender doesn't match target gender
		render :profile
	end

	def preferences #show/edit route
		render :preferences
	end

	def update 
	#if i actually save to DB and not hold everything in sessions
	end

	def destroy
	#if i actually save to DB and not hold everything in sessions
	end


	private

	def parse_profile_pics(response)
		albums = response['albums']['data']
		albums.each do |album|
			if album['name'] == 'Profile Pictures'
				pp = album
			end
			pp
		end
	end

	# finds the first album which may not always be the profile album >> url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums.limit(1){photos.limit(10){name,link}}"
	
end#VC