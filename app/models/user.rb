class User < ApplicationRecord
  belongs_to :workspace
  has_many :audit_logs, dependent: :destroy
  has_secure_password
  ROLES = %w[admin agent viewer].freeze
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: ROLES }

  def admin? = role == "admin"
  def can_manage_tickets? = role.in?(%w[admin agent])
end
