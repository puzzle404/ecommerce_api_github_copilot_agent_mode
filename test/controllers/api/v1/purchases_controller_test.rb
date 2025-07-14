require "test_helper"

class Api::V1::PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    @purchase = purchases(:one)
    sign_in @user
  end

  test "should get index" do
    get api_v1_purchases_url
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal @purchase.id, body.first["id"]
  end

  test "should create purchase" do
    assert_difference("Purchase.count") do
      post api_v1_purchases_url, params: {
        purchase: {
          product_id: products(:one).id,
          customer_id: users(:customer_user).id,
          purchase_date: Date.today,
          quantity: 1,
          total_price: 50
        }
      }
    end
    assert_response :created
  end

  test "should get count" do
    get count_api_v1_purchases_url(granularity: 'day')
    assert_response :success
    body = JSON.parse(@response.body)
    assert body.values.first.to_i >= 1
  end
end
