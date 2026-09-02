class Call < ApplicationRecord
  belongs_to :caller, polymorphic: true
  belongs_to :callee, polymorphic: true

  validates :status, inclusion: { in: %w[pending ringing active ended failed] }

  scope :active, -> { where(status: %w[pending ringing active]) }
  scope :completed, -> { where(status: %w[ended failed]) }
end
