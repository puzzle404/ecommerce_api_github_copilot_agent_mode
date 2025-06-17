class Api::V1::ProductsController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    # products = Product.all
    # render json: products
    productos = Product.select(:id, :name, :price, :stock)
    render json: { productos: productos }
  end

  def show
    render json: @product
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  def top_revenue
    products = Product
      .left_joins(:purchases)
      .select('products.*, COALESCE(SUM(purchases.total_price), 0) AS total_revenue')
      .group('products.id')
      .order('total_revenue DESC')
      .limit(3)

    render json: products.as_json(methods: :total_revenue)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :stock, :description, :administrator_id)
  end
end
