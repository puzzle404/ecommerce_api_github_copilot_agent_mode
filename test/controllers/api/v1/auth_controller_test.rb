require "test_helper"

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'login with valid credentials returns jwt token' do
    user = users(:admin_user)
    post '/api/v1/auth/login', params: { email: user.email, password: 'password' }

    assert_response :success
    body = JSON.parse(@response.body)
    assert body['token'].present?, 'Token should be present'
  end

  test 'login with invalid credentials returns unauthorized' do
    user = users(:admin_user)
    post '/api/v1/auth/login', params: { email: user.email, password: 'wrong' }

    assert_response :unauthorized
    body = JSON.parse(@response.body)
    assert_equal 'Invalid Email or Password', body['error']
  end
end
