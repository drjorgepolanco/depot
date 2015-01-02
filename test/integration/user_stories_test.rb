require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

	test "buying a product" do
		LineItem.delete_all
		Order.delete_all
		ruby_book = products(:ruby)
		# A user goes to the store
		get "/"
		assert_response :success
		assert_template "index"
		# The user select a product (AJAX involved) and...
		xml_http_request :post, '/line_items', product_id: ruby_book.id
		assert_response :success
		# adds it to his cart
		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product
		# Then, the user checks out
		get "/orders/new"
		assert_response :success
		assert_template "new"
		# the user has fills in his details on the checkout form
		post_via_redirect "/orders",
											order: { name: "Julito Triculi",
															 address: "123 Elm Street",
															 email: "triculito@example.com",
															 pay_type: "Check" }
		# The application creates the order and redirects to the index page													 
		assert_response :success
		assert_template "index"
		# Check that the cart is now empty
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size
		# Next, we make sure we’ve created an order. Because we cleared the orders 
		# table, we’ll simply verify that it now contains just our new order,
		orders = Order.all
		assert_equal 1, orders.size
		order = orders[0]
		# And that the details they contain are correct. 
		assert_equal "Julito Triculi", 				order.name
		assert_equal "123 Elm Street", 				order.address
		assert_equal "triculito@example.com", order.email
		assert_equal "Check", 								order.pay_type
		# And that the corresponding line item is correct.
		assert_equal 1, order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product
		# Finally, we verify that mail is correctly addressed and has expected subject
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["triculito@example.com"], 					 mail.to
		assert_equal 'Sam Ruby <depot@example.com>', 			 mail[:from].value
		assert_equal "Pragmatic Store Order Confirmation", mail.subject
	end
end
