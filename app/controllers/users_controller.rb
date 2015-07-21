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
				redirect_to "/users/#{session[:user_id]}/photos"
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
#########################
#########################			
	def photos
	#repull current_user object out of DB
		current_user
		if current_user.photos != nil
			@array_img_links = current_user.photos.pluck(:img_url)
			render :photos
		else
	#API call to get profile photos
			headers = {
				:Authorization => "OAuth #{session[:access_token]}"
			}
			url = "https://graph.facebook.com/v2.4/#{@current_user.profile_album_id}?fields=photos.limit(10)%7Bimages%7D"

			@fb_response = JSON.parse( RestClient.get(url, headers) )
			@array_img = parse_profile_photos(@fb_response)
			create_and_save_photo_entries(@array_img)
			@array_img_links = current_user.photos.pluck(:img_url)
			render :photos
		end
	end
##########################
#########################	
	def prefs
		current_user
		render :prefs
	end
#########################
#########################	
	def loading
		current_user
		@redirect_url = "#{ROOT}/browse"
		@referrer_id = session[:referrer_id]
		render :loading
	end
#########################
#########################	
	def share
		current_user
		session[:referrer_id] = current_user.referrer_id
		render :share
	end
#########################
#########################	
	def browse
		current_user
		if session[:referrer_id]
			@admin = Admin.find_by({referrer_id: session[:referrer_id]})
			@photos = @admin.photos.pluck(:img_url)
			render :browse
		else
			redirect_to '/'
		end
	end

	def get_images
		current_user
		admin = Admin.find_by({referrer_id: session[:referrer_id]})
		@photos = admin.photos.pluck(:img_url)
		respond_to do |format|
			format.html
			format.json { render json: @photos }
		end
	end
#########################
#########################	
	def convert
		current_user
		render :convert
	end
#########################
#########################	
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
#########################
#########################	
	def referral
		session[:referrer_id] = params[:referrer_id]
		redirect_to "/"
	end
#########################
#########################	
	def profile
		current_user
		render :profile
	end
#########################
#########################	
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
#########################
#########################	
	def logout
		session[:user_id] = nil
		redirect_to '/'
	end
#########################
#########################	
	private

	def parse_profile_album_id(response)
		albums = response['albums']['data']
		profile_album = albums.select{|album| album['name'] == "Profile Pictures"}
		profile_album[0]['id']
	end

	def parse_profile_photos(response)
		img_obj_array = []
		img_links = []
		data = response['photos']['data']
		data.map do |img_obj|
			img_obj_array.push( img_obj['images'].first )
		end
		img_obj_array.map do |img|
			img_links.push(img['source'])
		end
		img_links
	end

	def create_and_save_photo_entries(array)
		array.each do |photo|
			new_photo = Photo.new({
				img_url: photo,
				admin_id: session[:user_id]
			})
			new_photo.save
		end
	end

end#UC