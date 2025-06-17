class Api::V1::AuditsController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    audits = Audit.order(created_at: :desc).limit(100)
    render json: audits
  end
end