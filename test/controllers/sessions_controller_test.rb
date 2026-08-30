require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "redirects guests to login" do
    get root_url
    assert_redirected_to login_url
  end

  test "signs in with valid demo credentials" do
    sign_in
    assert_redirected_to root_url
    follow_redirect!
    assert_response :success
  end

  test "rejects invalid credentials" do
    post login_url, params: { email: demo_user.email, password: "wrong" }
    assert_response :unprocessable_entity
  end

  test "signs out" do
    sign_in
    delete logout_url
    assert_redirected_to login_url
  end
end
