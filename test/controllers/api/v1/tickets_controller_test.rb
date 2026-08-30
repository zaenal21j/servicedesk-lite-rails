require "test_helper"

class Api::V1::TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = demo_user
    @user.update!(api_token: "test-api-token")
    @customer = @user.workspace.customers.create!(name: "API Customer", email: "api@example.com")
    @ticket = @customer.tickets.create!(subject: "API ticket", description: "Created for API tests", status: "open", priority: "medium")
    @headers = { "Authorization" => "Bearer test-api-token" }
  end

  test "requires a bearer token" do
    get api_v1_tickets_url
    assert_response :unauthorized
  end

  test "lists only tickets in the token workspace" do
    other = Workspace.create!(name: "Other", slug: "api-other")
    customer = other.customers.create!(name: "Hidden", email: "hidden@example.com")
    customer.tickets.create!(subject: "Hidden ticket", description: "Private", status: "open", priority: "low")

    get api_v1_tickets_url, headers: @headers
    assert_response :success
    assert_includes response.body, "API ticket"
    refute_includes response.body, "Hidden ticket"
  end

  test "creates a ticket and audit entry" do
    assert_difference(["Ticket.count", "AuditLog.count"]) do
      post api_v1_tickets_url, headers: @headers, params: {
        ticket: { customer_id: @customer.id, subject: "Created by API", description: "Integration request", status: "open", priority: "high" }
      }
    end
    assert_response :created
  end

  test "viewer token cannot create tickets" do
    viewer = User.create!(email: "api-viewer@example.com", password: "demo1234", workspace: @user.workspace, role: "viewer", api_token: "viewer-token")
    post api_v1_tickets_url, headers: { "Authorization" => "Bearer #{viewer.api_token}" }, params: {
      ticket: { customer_id: @customer.id, subject: "Blocked", description: "Blocked", status: "open", priority: "low" }
    }
    assert_response :forbidden
  end
end
