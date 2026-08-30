class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]
  before_action :require_admin, except: %i[index show]

  def index
    @customers = current_workspace.customers.order(:name)
    render_customer_view(:index)
  end
  def show = render_customer_view(:show)
  def new
    @customer = current_workspace.customers.new
    render_customer_view(:new)
  end
  def edit = render_customer_view(:edit)

  def create
    @customer = current_workspace.customers.new(customer_params)
    if @customer.save
      record_audit("customer.created", @customer, @customer.saved_changes)
      return redirect_to(@customer, notice: "Customer created.")
    end

    render_customer_view(:new, status: :unprocessable_entity)
  end

  def update
    if @customer.update(customer_params)
      record_audit("customer.updated", @customer, @customer.saved_changes)
      return redirect_to(@customer, notice: "Customer updated.")
    end

    render_customer_view(:edit, status: :unprocessable_entity)
  end

  def destroy
    record_audit("customer.deleted", @customer, name: @customer.name)
    @customer.destroy
    redirect_to customers_path, notice: "Customer removed."
  end

  private

  def set_customer = @customer = current_workspace.customers.find(params[:id])
  def customer_params = params.require(:customer).permit(:name, :email, :company, :phone)
  def render_customer_view(name, status: :ok) = render_app_view("customers/#{name}", status: status)
end
