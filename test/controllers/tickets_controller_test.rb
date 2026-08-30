require "test_helper"

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in
    @customer = demo_user.workspace.customers.create!(name: "Test Customer", email: "test@example.com")
  end
  test "lists tickets" do
    get tickets_url
    assert_response :success
  end

  test "filters tickets" do
    get tickets_url, params: { status: "open", q: "Export" }
    assert_response :success
  end

  test "creates a ticket" do
    assert_difference("Ticket.count") do
      post tickets_url, params: { ticket: { customer_id: @customer.id, subject: "Export error", description: "CSV export fails", status: "open", priority: "high" } }
    end
    assert_redirected_to ticket_url(Ticket.last)
  end

  test "viewer cannot create tickets" do
    viewer = User.create!(email: "viewer@example.com", password: "demo1234", workspace: demo_user.workspace, role: "viewer")
    delete logout_url
    sign_in(viewer)

    get new_ticket_url
    assert_redirected_to tickets_url
  end
end
