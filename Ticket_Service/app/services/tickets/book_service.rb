module Tickets
  class BookService
    Result = Struct.new(:success?, :message, :errors)
  
    def initialize(params)
        @ticket_category_name = params[:ticket_category_name]
        @event_date = params[:event_date]
    end
  
    def call
      category = TicketCategory.find_by(name: @ticket_category_name)
      ticket = Ticket.where(ticket_category_id: category.id, event_date: @event_date, status: 'available').first
      return Result.new(false, nil, "Ticket not found") unless ticket

      price_result = Tickets::PriceService.new({ category: ticket.ticket_category.name, event_date: @event_date }).call
      if price_result.success?
        computed_price = price_result.data
      else
        return Result.new(false, nil, "Price service internal error")
      end
  
      if ticket.update(status: 'booked', current_price: computed_price)
        booking = Booking.create(
          ticket: ticket,
          reserved_at: Time.current,
          expires_at: Time.current + 5.minutes,
          status: 'booked'
        )
  
        if booking.persisted?
          Tickets::ExpireBookingWorker.perform_in(5.minutes, booking.id)
          Result.new(true, { ticket_id: ticket.id, book_id: booking.id, current_price: computed_price }, nil)
        else
          Result.new(false, nil, booking.errors.full_messages)
        end
      else
        Result.new(false, nil, ticket.errors.full_messages)
      end
    rescue => e
      Result.new(false, nil, "Internal error: #{e.message}")
    end
  end
end
  