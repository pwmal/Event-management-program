class Ticket < ApplicationRecord
  validates :status, inclusion: { in: ['booked', 'blocked', 'purchased', 'available'], message: "%{value} is not a valid status" }
  belongs_to :ticket_category
  has_many :bookings, dependent: :destroy
  has_one :purchase, dependent: :destroy
  has_one :ticket_block, dependent: :destroy
end
