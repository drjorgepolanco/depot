module CurrentCart
	extend ActiveSupport::Concern

	private

		def set_cart
			# Gets the :cart_id from the session object and
			# attemps to find a cart corresponding to this ID.
			@cart = Cart.find(session[:cart_id])
		rescue ActiveRecord::RecordNotFound
			# If no carts where found, it creates a new one.
			@cart = Cart.create
			session[:cart_id] = @cart.id
		end
end

# We place the set_cart() method in a CurrentCart module and mark it as private. 
# This allows us to share common code between controllers and prevents Rails 
# from making it available as an action on the controller.