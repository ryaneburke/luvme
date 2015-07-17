class Admin < User

	has_many :viewers
	has_many :photos
	
end