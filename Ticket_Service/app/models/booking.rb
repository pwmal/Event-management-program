class Booking < ApplicationRecord
  validates :status, inclusion: { in: ['booked', 'purchased', 'expired', 'canceled'], message: "%{value} is not a valid status" }
  belongs_to :ticket
end
