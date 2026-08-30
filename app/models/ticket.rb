class Ticket < ApplicationRecord
  belongs_to :customer
  STATUSES = %w[open in_progress resolved].freeze
  PRIORITIES = %w[low medium high].freeze
  validates :subject, :description, :status, :priority, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
  validate :customer_belongs_to_current_workspace

  attr_accessor :current_workspace

  private

  def customer_belongs_to_current_workspace
    return unless current_workspace && customer && customer.workspace_id != current_workspace.id

    errors.add(:customer, "must belong to the current workspace")
  end
end
