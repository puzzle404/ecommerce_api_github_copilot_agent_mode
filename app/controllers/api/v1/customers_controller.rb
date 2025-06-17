class Api::V1::CustomersController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    render json: User.where(admin: false)
  end

  def create
    customer = User.new(customer_params.merge(admin: false))
    if customer.save
      render json: customer, status: :created
    else
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :password, :password_confirmation, :address)
  end
end