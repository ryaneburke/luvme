class UsersController < ApplicationController
	skip_before_action :verify_authenticity_token

	def new #profile
	#API call to get relevant User data
		headers = {
			:Authorization => "OAuth #{session[:access_token]}"
		}
		url = "https://graph.facebook.com/v2.4/me?fields=first_name,gender,location,albums"
		@fb_response = JSON.parse( RestClient.get(url, headers) )
		profile_album_id = parse_profile_album_id(@fb_response)
		user = User.find_by({profile_album_id: profile_album_id})
	#does the user already exist in the DB?
		if user
			#did user come in with a referrer_id?
			#send user to browse
			if session[:referrer_id]
				session[:user_id] = user.id
				redirect_to "/browse"
			else
			#if they didn't come here to look, they came here to make
			#send them to photos so they can make their own version	
				@user = user
				session[:user_id] = user.id
				redirect_to "/users/#{session[:user_id]}/convert"
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
					redirect_to "/users/#{@user.id}/photos"
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
					redirect_to "/users/#{@user.id}/prefs"
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
		url = "https://graph.facebook.com/v2.4/#{@current_user.profile_album_id}?fields=photos.limit(10)%7Bimages%7D"

		@fb_response = JSON.parse( RestClient.get(url, headers) )

		
		
		# create_and_save_photo_entries(@photo_array)
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
		current_user
		render :convert
	end

	def switch_types
		current_user
		@current_user.type = 'admin'
		if @current_user.save
			session[:referrer_id] = nil
			redirect_to "/users/<%= @current_user.id %>/photos"
		else
			render :'/errors/switch'
		end
	end

	def profile
		current_user
		render :profile
	end

	def update
		@user = User.find(params['id'])
		@user.update({
			fname: params['fname'],
			location: params['location'],
			gender: params['gender'] 
		})
		if @user.admin?
			redirect_to "/users/#{@user.id}/photos"
		else
			redirect_to "/users/#{@user.id}/prefs"
		end
	end
	
	private

	def parse_profile_album_id(response)
		albums = response['albums']['data']
		profile_album = albums.select{|album| album['name'] == "Profile Pictures"}
		profile_album[0]['id']
	end

	def parse_profile_photos(response)
		photo_array = []
		just_links = []
		data = response['photos']['data']
		data.map do |one_pic|
			holding_var = one_pic['images'].select{|img| img['width'] == 600}
			photo_array.push(holding_var)
		end
		flattened_photo_array = photo_array.flatten
		flattened_photo_array.map do |photo|
			just_links.push(photo['source'])
		end
		just_links
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