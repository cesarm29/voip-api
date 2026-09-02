class User < ApplicationRecord
  has_secure_password
  has_many :devices, dependent: :destroy

  attribute :role, :string, default: "user"
  attribute :status, :string, default: "offline"

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: %w[admin user] }
  validates :status, inclusion: { in: %w[online offline busy] }
end
