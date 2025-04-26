module Tickets
  class CancelService
    Result = Struct.new(:success?, :message, :errors)
  
    def initialize(book_id)
      @book_id = book_id
    end
  
    def call
      booking = Booking.find_by(id: @book_id)
      return Result.new(false, nil, "Booking not found") unless booking

      if booking.status != 'booked'
        return Result.new(false, nil, "Booking cannot be canceled. It's either already canceled or purchased.")
      end
  
      ticket = booking.ticket
  
      booking.update(status: 'canceled')

      ticket.update(status: 'available')

      Result.new(true, "Booking canceled successfully", nil)
    rescue => e
      Result.new(false, nil, "Internal error: #{e.message}")
    end
  end
end
  