class Api::V1::AdministratorsController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    render json: User.where(admin: true)
  end

  def create
    admin = User.new(admin_params.merge(admin: true))
    if admin.save
      render json: admin, status: :created
    else
      render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def admin_params
    params.require(:administrator).permit(:name, :email, :password, :password_confirmation)
  end
end