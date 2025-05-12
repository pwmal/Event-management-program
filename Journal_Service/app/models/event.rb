class Event < ApplicationRecord
  validates :ticket_id, presence: true
  validates :full_name, presence: true
  validates :time, presence: true
  validates :event_type, presence: true
  validates :status, presence: true
end
