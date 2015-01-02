class Order < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	PAYMENT_TYPES = [ "Check", "Credit Card", "Purchase Order" ]
	validates :name, :address, :email, presence: true
	validates :pay_type, inclusion: PAYMENT_TYPES

	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			# prevent the item from going poof when we destroy the cart
			item.cart_id = nil
			# add the item itself to the line_items collection for the order
			line_items << item
		end
	end
end
