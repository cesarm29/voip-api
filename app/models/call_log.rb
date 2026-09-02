class CallLog < ApplicationRecord
  belongs_to :caller, class_name: "User", optional: true
  belongs_to :callee, class_name: "User", optional: true
  belongs_to :room, optional: true

  scope :recent, -> { order(created_at: :desc).limit(50) }
end
