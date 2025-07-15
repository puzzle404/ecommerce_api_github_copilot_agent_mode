class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def create
    @purchase = current_user.purchases.new(purchase_params)
    if @purchase.save
      redirect_to products_path, notice: 'Purchase completed!'
    else
      redirect_to product_path(@purchase.product), alert: 'Failed to purchase.'
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:product_id, :quantity, :total_price, :purchase_date)
  end
end
