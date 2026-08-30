class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show edit update destroy]
  before_action :require_ticket_manager, except: %i[index show]

  def index
    @tickets = current_workspace.tickets.includes(:customer).order(created_at: :desc)
    @tickets = @tickets.where(status: params[:status]) if Ticket::STATUSES.include?(params[:status])
    @tickets = @tickets.where("subject LIKE :query OR description LIKE :query", query: "%#{params[:q]}%") if params[:q].present?
    render_ticket_view(:index)
  end

  def show = render_ticket_view(:show)
  def new
    @ticket = Ticket.new(status: "open", priority: "medium", current_workspace: current_workspace)
    render_ticket_view(:new)
  end
  def edit = render_ticket_view(:edit)

  def create
    @ticket = Ticket.new(ticket_params.merge(current_workspace: current_workspace))
    if @ticket.save
      record_audit("ticket.created", @ticket, @ticket.saved_changes)
      return redirect_to(@ticket, notice: "Ticket created.")
    end

    render_ticket_view(:new, status: :unprocessable_entity)
  end

  def update
    @ticket.current_workspace = current_workspace
    if @ticket.update(ticket_params)
      record_audit("ticket.updated", @ticket, @ticket.saved_changes)
      return redirect_to(@ticket, notice: "Ticket updated.")
    end

    render_ticket_view(:edit, status: :unprocessable_entity)
  end

  def destroy
    record_audit("ticket.deleted", @ticket, subject: @ticket.subject)
    @ticket.destroy
    redirect_to tickets_path, notice: "Ticket removed."
  end

  private

  def set_ticket = @ticket = current_workspace.tickets.find(params[:id])
  def ticket_params = params.require(:ticket).permit(:customer_id, :subject, :description, :status, :priority)
  def render_ticket_view(name, status: :ok) = render_app_view("tickets/#{name}", status: status)
end
