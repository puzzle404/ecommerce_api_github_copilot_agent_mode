class Api::V1::TokensController < Api::V1::BaseController
  before_action :authenticate_user!

  def show
    token = request.headers['Authorization']&.split(' ')&.last
    seconds_left = nil
    expired = false
    if token
      begin
        payload = JWT.decode(token, nil, false).first
        exp = payload['exp']
        seconds_left = exp ? (exp - Time.now.to_i) : nil
        expired = seconds_left && seconds_left <= 0
      rescue
        expired = true
      end
    else
      expired = true
    end

    if expired
      render json: { error: 'El token ha expirado' }, status: :unauthorized
    else
      render json: {
        user: current_user.email,
        seconds_left: seconds_left
      }
    end
  end
end