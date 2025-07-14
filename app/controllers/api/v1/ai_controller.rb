class Api::V1::AiController < Api::V1::BaseController
  before_action :authenticate_user!

  def summary
    result = AiClient.new.purchases_summary(current_user)
    render json: { summary: result }
  end
end
