require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login when not authenticated" do
    get dashboard_index_url
    assert_redirected_to new_session_url
  end
end