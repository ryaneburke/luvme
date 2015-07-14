class UsersController < ApplicationController

	def new
		if !session[:app_id]
		#API call to get relevant User data
			headers = {
				:Authorization => "OAuth #{session[:access_token]}"
			}
			url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums"
			@user = JSON.parse( RestClient.get(url, headers) )
		#new_user object
			new_user = User.new({
				fname: @user['first_name'],
				gender: @user['gender'],
				location: @user['location'],
				profile_album_id: parse_profile_album_id(@user),
				type: 'Admin'
			})
		#saving new_user to DB
			if new_user.save
				session[:user_id] = new_user.user_id
				render :profile
			else
				redirect_to "/users/new"
			end
		#need to build redirect if gender doesn't match target gender
		end
	end

	def photos
	#repull current_user object out of DB
		@user = User.find(session[:user_id])
	#API call to get profile photos
		headers = {
			:Authorization => "OAuth #{session[:access_token]}"
		}
		url = "#{user.profile_album_id}/photos?fields=images&limit=10"
		fb_response = JSON.parse( RestClient.get(url, headers) )

		@photo_array = parse_profile_photos(fb_response)
		create_and_save_photo_entries(@photo_array)
		render :photos
	end

	def loading
		render :loading
	end

	def share
		render :share
	end

	def show
		render :show
	end
	
	private

	def parse_profile_album_id(response)
		albums = response['albums']['data']
		albums.each do |album|
			if album['name'] == 'Profile Pictures'
				pp = album
			end
			pp
		end
	end

	def parse_profile_photos(response, width)
		photo_array = []
		data = response[:data]
		data.each do |single_pic|
			single_pic[:images].each do |size|
				if size[:width] == width
					photo_array.push(size[:source])
				end
			end
		end
		photo_array
	end

	def create_and_save_photo_entries(array)
		array.each do |photo|
			new_photo = Photo.new({
				img_url: photo,
				user_id: session[:user_id]
			})
			new_photo.save
		end
	end

end