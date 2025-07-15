class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_login_page?

  private

  def devise_login_page?
    controller_name == 'sessions' && action_name == 'new'
  end
end
