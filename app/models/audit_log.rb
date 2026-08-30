class AuditLog < ApplicationRecord
  belongs_to :workspace
  belongs_to :user

  validates :action, :record_type, :record_id, presence: true
end
