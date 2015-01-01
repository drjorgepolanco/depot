class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy

	def add_product(product_id)
		current_item = line_items.find_by(product_id: product_id)
		if current_item
			# Updates the item quantity if it already exists in the cart
			current_item.quantity += 1
		else
			# Or create a new one if not
			current_item = line_items.build(product_id: product_id)
		end
		current_item
	end
end
