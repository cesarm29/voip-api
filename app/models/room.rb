class Room < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :max_participants, numericality: { greater_than: 1 }, allow_nil: true

  scope :active, -> { where(active: true) }
end
