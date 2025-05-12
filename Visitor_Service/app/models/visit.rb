class Visit < ApplicationRecord
  validates :ticket_id, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: ["in", "out"], message: "%{value} is not a valid status" }
end
