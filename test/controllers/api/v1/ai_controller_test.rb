require "test_helper"

class Api::V1::AiControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:customer_user)
    sign_in @user
  end

  test "should get summary" do
    OpenAI::Client.any_instance.stub(:chat, {"choices" => [{"message" => {"content" => "Resumen"}}]}) do
      post api_v1_ai_summary_url
    end
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal "Resumen", body["summary"]
  end
end
