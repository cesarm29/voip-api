class Device < ApplicationRecord
  belongs_to :user
  validates :sip_address, uniqueness: true, allow_nil: true
  validates :name, presence: true

  scope :online, -> { where(status: "online") }
end
