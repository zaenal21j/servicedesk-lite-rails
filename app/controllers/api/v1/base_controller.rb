module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user

      private

      attr_reader :current_api_user

      def current_workspace = current_api_user.workspace

      def authenticate_api_user
        token = request.authorization.to_s.delete_prefix("Bearer ")
        @current_api_user = User.find_by(api_token: token) if token.present?
        render json: { error: "Unauthorized" }, status: :unauthorized unless current_api_user
      end

      def require_api_writer
        render json: { error: "Read-only role" }, status: :forbidden unless current_api_user.can_manage_tickets?
      end
    end
  end
end
