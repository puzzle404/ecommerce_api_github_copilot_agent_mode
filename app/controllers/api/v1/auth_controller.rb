class Api::V1::AuthController < Api::V1::BaseController
  def login
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      # Genera el JWT manualmente, sin sesión
      token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid Email or Password' }, status: :unauthorized
    end
  end
end