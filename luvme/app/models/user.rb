class User < ActiveRecord::Base

	def admin?
		self.type == 'Admin'
	end

	def viewer?
		self.type == 'Viewer'
	end

end