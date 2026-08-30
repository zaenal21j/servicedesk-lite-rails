class Workspace < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :tickets, through: :customers
  has_many :audit_logs, dependent: :destroy

  validates :name, presence: true
end
