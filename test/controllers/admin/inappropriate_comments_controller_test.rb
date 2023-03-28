require "test_helper"

class Admin::InappropriateCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_inappropriate_comments_index_url
    assert_response :success
  end
end
