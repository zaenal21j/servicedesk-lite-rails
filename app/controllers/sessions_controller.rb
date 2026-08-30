class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    render_app_view("sessions/new")
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome back."
    else
      flash.now[:alert] = "Email or password is incorrect."
      render_app_view("sessions/new", status: :unprocessable_entity)
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "You have been signed out."
  end

end
