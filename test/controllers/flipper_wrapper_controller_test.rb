require 'test_helper'

class FlipperWrapperControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get flipper_wrapper_index_url
    assert_response :success
  end

end
