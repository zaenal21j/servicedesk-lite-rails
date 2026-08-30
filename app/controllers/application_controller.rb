class ApplicationController < ActionController::Base
  before_action :require_login
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :current_workspace, :inline_partial

  def render_app_view(relative_path, status: :ok)
    page_source = template_source("layouts/application").sub("<%= yield %>", template_source(relative_path))
    render inline: page_source, type: :erb, layout: false, status: status
  end

  def inline_partial(relative_path, locals = {})
    render_to_string inline: template_source(relative_path), type: :erb, layout: false, locals: locals
  end

  private

  def current_user = @current_user ||= User.find_by(id: session[:user_id])
  def current_workspace = current_user&.workspace
  def require_login
    redirect_to login_path, alert: "Please sign in to continue." unless current_user
  end

  def template_source(relative_path)
    File.read(Rails.root.join("app/views/#{relative_path}.html.erb"))
  end

  def require_admin
    redirect_to root_path, alert: "Administrator access is required." unless current_user&.admin?
  end

  def require_ticket_manager
    redirect_to tickets_path, alert: "Your role has read-only access." unless current_user&.can_manage_tickets?
  end

  def record_audit(action, record, changes = {})
    current_workspace.audit_logs.create!(
      user: current_user,
      action: action,
      record_type: record.class.name,
      record_id: record.id,
      metadata: changes.to_json
    )
  end
end
