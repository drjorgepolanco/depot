class LineItemsController < ApplicationController
  include CurrentCart
  before_action      :set_cart, only: :create
  before_action      :set_line_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: :create

  def index
    @line_items = LineItem.all
  end

  def show
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
    # # Creates a new simple line_item
    # @line_item = LineItem.new(line_item_params)

    # Links the product with the line_item being created
    product = Product.find(params[:product_id])
    # @line_item = @cart.line_items.build(product: product)

    # Allows updating quantity when the product already exists in the cart
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url } #@line_item.cart
        format.js   { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, 
                      status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, 
                      notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, 
                      status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url, 
                    notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    def line_item_params
      # params.require(:line_item).permit(:product_id, :cart_id)

      # Remove :cart_id to avoid this parameter being permitted to be modified.
      params.require(:line_item).permit(:product_id)
    end
end
