class User < ActiveRecord::Base
	
	before_save :assign_referrer_id
	# before_save :parse_profile_album_id

	def admin?
		self.type == 'admin'
	end

	def viewer?
		self.type == 'viewer'
	end

	def assign_referrer_id
		self.referrer_id = SecureRandom.urlsafe_base64()
	end

	def assign_profile_album_id
		self.profile_album_id = parse_profile_album_id(response)
	end

	def parse_profile_album_id(response)
		albums = response['albums']['data']
		profile_album = albums.select{|album| album['name'] == "Profile Pictures"}
		profile_album[0]['id']
	end

	# set the profile_album_id: 197398721
	# profile_album_id: parse_profile_album_id(@user)
	# def parse_profile_album_id(response)
	# 	albums = response['albums']['data']
	# 	albums.each do |album|
	# 		if album['name'] == 'Profile Pictures'
	# 			pp = album #probably should be album['id']
	# 		end
	# 		pp
	# 	end
	# end

end

