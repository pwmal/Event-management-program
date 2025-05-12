class Tickets::ExpireBookingWorker
  include Sidekiq::Worker
  
  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    if booking && booking.status == 'booked' && Time.current > booking.expires_at
      ticket = booking.ticket
      booking.update(status: 'expired')
      ticket.update(status: 'available')
    end
  end
end