require "test_helper"

class GamePostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get game_posts_index_url
    assert_response :success
  end
end
