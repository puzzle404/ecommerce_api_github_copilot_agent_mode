require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin_user)
    @product = products(:one)
    sign_in @admin
  end

  test "should get index" do
    get api_v1_products_url
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal @product.id, body["productos"].first["id"]
  end

  test "should create product" do
    assert_difference("Product.count") do
      post api_v1_products_url, params: {
        product: {
          name: "Phone",
          price: 500,
          stock: 10,
          description: "Smart phone",
          administrator_id: @admin.id,
          category_id: categories(:one).id
        }
      }
    end
    assert_response :created
  end

  test "should get top revenue" do
    get top_revenue_api_v1_products_url
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal @product.id, body.first["id"]
    assert body.first["total_revenue"].to_f > 0
  end
end
