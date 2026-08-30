class DashboardController < ApplicationController
  def index
    @customers_count = current_workspace.customers.count
    @tickets_count = current_workspace.tickets.count
    @open_tickets = current_workspace.tickets.where.not(status: "resolved").count
    @recent_tickets = current_workspace.tickets.includes(:customer).order(created_at: :desc).limit(5)
    render_app_view("dashboard/index")
  end
end
