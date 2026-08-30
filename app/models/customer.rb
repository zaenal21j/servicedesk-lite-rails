class Customer < ApplicationRecord
  belongs_to :workspace
  has_many :tickets, dependent: :destroy
  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
