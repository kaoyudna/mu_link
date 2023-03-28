require "test_helper"

class Public::MusicsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_musics_show_url
    assert_response :success
  end
end
