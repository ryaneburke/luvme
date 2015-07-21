class DemoController < ApplicationController

	def prefs
		@demo = true
		render :"users/prefs"
	end

	def loading
		@redirect_url = "#{ROOT}/demo/browse"
		render :"users/loading"
	end

	def browse
		if session[:referrer_id]
			@demo = true
			@admin = Admin.find_by({referrer_id: session[:referrer_id]})
			@current_user = @admin
			@photos = @admin.photos.pluck(:img_url)
			render :"users/browse"
		else
			redirect_to '/'
		end
	end

	def convert
		@demo = true
		render :"users/convert"
	end

	def share
		render :"users/share"
	end

end