class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart,  only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    # prevents users from navigating to checkout and creating empty orders
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      # Without return we'll get a double render error:
      # controller will attemp to both redirect and render output
      return
    end
    @order = Order.new
  end

  def edit
  end

  def create
    # Capture the values from the form to populate a new Order model object.
    @order = Order.new(order_params)
    # Add the line items from our cart to that order.
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      # Validates and save the order. If it fails, displays appropriate messages,
      # and let the user correct any problems.
      if @order.save
        # If the order is successfully saved, delete the cart
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        # Send email
        OrderNotifier.received(@order).deliver_now
        # redisplay catalog page, and display confirmation message.
        format.html { redirect_to store_url, notice: 'Than you for your order.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
end
