class CombineItemsInCart < ActiveRecord::Migration
  def up
  	# Replace multiple items for a single product in a cart with a single item
  	Cart.all.each do |cart|
  		# Count the number of each product in the cart
  		sums = cart.line_items.group(:product_id).sum(:quantity)
  		sums.each do |product_id, quantity|
  			if quantity > 1
  				# Remove individual items
  				cart.line_items.where(product_id: product_id).delete_all
  				# Replace with a single item
  				item = cart.line_items.build(product_id: product_id)
  				item.quantity = quantity
  				item.save!
  			end
  		end
  	end
  end
end
