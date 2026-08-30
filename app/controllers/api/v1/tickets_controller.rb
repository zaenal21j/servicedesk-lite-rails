module Api
  module V1
    class TicketsController < BaseController
      before_action :require_api_writer, only: %i[create update]
      before_action :set_ticket, only: %i[show update]

      def index
        tickets = current_workspace.tickets.includes(:customer).order(created_at: :desc)
        tickets = tickets.where(status: params[:status]) if Ticket::STATUSES.include?(params[:status])
        render json: tickets.map { |ticket| ticket_json(ticket) }
      end

      def show
        render json: ticket_json(@ticket)
      end

      def create
        ticket = Ticket.new(ticket_params.merge(current_workspace: current_workspace))
        if ticket.save
          audit("api.ticket.created", ticket, ticket.saved_changes)
          render json: ticket_json(ticket), status: :created
        else
          render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @ticket.current_workspace = current_workspace
        if @ticket.update(ticket_params)
          audit("api.ticket.updated", @ticket, @ticket.saved_changes)
          render json: ticket_json(@ticket)
        else
          render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_ticket = @ticket = current_workspace.tickets.find(params[:id])
      def ticket_params = params.require(:ticket).permit(:customer_id, :subject, :description, :status, :priority)

      def ticket_json(ticket)
        ticket.as_json(only: %i[id subject description status priority created_at updated_at]).merge(
          customer: ticket.customer.as_json(only: %i[id name email company])
        )
      end

      def audit(action, record, changes)
        current_workspace.audit_logs.create!(user: current_api_user, action: action, record_type: "Ticket", record_id: record.id, metadata: changes.to_json)
      end
    end
  end
end
