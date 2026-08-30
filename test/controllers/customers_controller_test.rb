require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in
    @customer = demo_user.workspace.customers.create!(name: "Test Customer", email: "test@example.com")
  end
  test "lists customers" do
    get customers_url
    assert_response :success
  end

  test "shows a customer" do
    get customer_url(@customer)
    assert_response :success
  end

  test "creates a customer" do
    assert_difference("Customer.count") do
      post customers_url, params: { customer: { name: "Ana Silva", email: "ana@example.com" } }
    end
    assert_redirected_to customer_url(Customer.last)
  end

  test "does not expose customers from another workspace" do
    other = Workspace.create!(name: "Other Company", slug: "other-company")
    outsider = other.customers.create!(name: "Private Customer", email: "private@example.com")

    get customer_url(outsider)
    assert_response :not_found
  end
end
