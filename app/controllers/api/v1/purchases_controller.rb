class Api::V1::PurchasesController < Api::V1::BaseController
  before_action :authenticate_user!

  # GET /api/v1/purchases
  def index
    purchases = Purchase.all

    # Filtros por params
    purchases = purchases.where(customer_id: params[:customer_id]) if params[:customer_id]
    purchases = purchases.where(product_id: params[:product_id]) if params[:product_id]
    purchases = purchases.where('purchase_date >= ?', params[:start_date]) if params[:start_date]
    purchases = purchases.where('purchase_date <= ?', params[:end_date]) if params[:end_date]
    purchases = purchases.where(category_id: params[:category_id]) if params[:category_id]
    purchases = purchases.where(administrator_id: params[:administrator_id]) if params[:administrator_id]

    render json: purchases
  end

  # POST /api/v1/purchases
  def create
    purchase = Purchase.new(purchase_params)
    if purchase.save
      render json: purchase, status: :created
    else
      render json: { errors: purchase.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/purchases/count?granularity=day
  def count
    granularity = params[:granularity] || 'day'
    group_by = case granularity
               when 'hour' then "DATE_TRUNC('hour', purchase_date)"
               when 'day' then "DATE_TRUNC('day', purchase_date)"
               when 'week' then "DATE_TRUNC('week', purchase_date)"
               when 'month' then "DATE_TRUNC('month', purchase_date)"
               else "DATE_TRUNC('day', purchase_date)"
               end

    counts = Purchase.group(group_by).count
    render json: counts
  end

  private

  def purchase_params
    params.require(:purchase).permit(:product_id, :customer_id, :purchase_date, :quantity, :total_price)
  end
end