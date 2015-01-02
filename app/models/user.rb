class User < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains

  private

  	def ensure_an_admin_remains
  		if User.count.zero?
  			raise "Can't delete last user" # Key concept
  		end
  	end
end

# Key concept: use an exception to indicate an error when deleting the user.
	# Purposes:
	# 1. Because it's raised inside a transaction, it causes an automatic rollback.
	# 2. signals the error back to the controller, where we use a begin/end 
	# => block to handle it and report the error to the user in the flash. 

	# If you only want to abort the transaction but not signal an exception, 
	# raise an ActiveRecord::Rollback exception instead, because this is the 
	# only exception that won’t be passed on by ActiveRecord::Base.transaction.