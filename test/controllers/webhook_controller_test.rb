require 'test_helper'

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get twitter" do
    get webhook_twitter_url
    assert_response :success
  end

  test "should get telegram" do
    get webhook_telegram_url
    assert_response :success
  end

end
