class UsersController < ApplicationController


	def new #profile
	#API call to get relevant User data
		headers = {
			:Authorization => "OAuth #{session[:access_token]}"
		}
		url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums"
		@fb_response = JSON.parse( RestClient.get(url, headers) )
		binding.pry
		user = User.find_by({profile_album_id: parse_profile_album_id(@fb_response)})
	#does the user already exist in the DB?
		if user
			#did user come in with a referrer_id?
			#send user to browse
			if session[:referrer_id]
				session[:user_id] = user.id
				redirect_to "/browse"
			else
			#if they didn't come here to look, they came here to make
			#send them to profile so they can make their own version	
				@user = user
				session[:user_id] = @user.id
				render :profile
			end
		else
			#user doesn't exist and doesn't have a referrer_id
			#create a new Admin, send to profile
			if !session[:referrer_id]
				#new_user object
				@user = Admin.new({
					fname: @fb_response['first_name'],
					gender: @fb_response['gender'],
					location: @fb_response['location'],
				})
				@user.assign_profile_album_id(@fb_response)
				if @user.save
					session[:user_id] = @user.id
					@user
					render :profile
				else
					redirect_to "/users/new"
				end
			else
			#user doesn't exist but has a referrer_id
			#create a new Viewer, send to profile	
				@user = Viewer.new({
					fname: @fb_response['first_name'],
					gender: @fb_response['gender'],
					location: @fb_response['location'],
				})
				@user.assign_profile_album_id(@fb_response)
				if @user.save
					session[:user_id] = @user.id
					@user
					render :profile
				else
					redirect_to "/users/new"
				end
			end	
		end
	end
		
	def photos
	#repull current_user object out of DB
		current_user
	#API call to get profile photos
		headers = {
			:Authorization => "OAuth #{session[:access_token]}"
		}
		url = "#{@current_user.profile_album_id}/photos?fields=images&limit=10"
		@fb_response = JSON.parse( RestClient.get(url, headers) )
		@photo_array = parse_profile_photos(@fb_response)
		create_and_save_photo_entries(@photo_array)
		render :photos
	end

	def prefs
		current_user
		render :prefs
	end

	def loading
		current_user
		@referrer_id = session[:referrer_id]
		render :loading
	end

	def share
		current_user
		session[:referrer_id] = current_user.referrer_id
		render :share
	end

	def browse
		if session[:referrer_id]
			@admin = Admin.find({referrer_id: session[:referrer_id]})
			@photos = @admin.photos.pluck(:img_url)
		end
	end

	def convert
		render :convert
	end

	def switch_types
		current_user
		@current_user.type = 'admin'
		if @current_user.save
			session[:referrer_id] = nil
			redirect_to '/users/<%= @current_user.id %>/photos'
		else
			render :'/errors/switch'
		end
	end


	end
	
	private

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

end#UC