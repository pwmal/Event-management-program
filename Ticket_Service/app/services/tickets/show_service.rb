module Tickets
  class ShowService
    Result = Struct.new(:success?, :message, :errors)
  
    def initialize(ticket_id)
      @ticket_id = ticket_id
    end
  
    def call
      ticket = Ticket.includes(:ticket_category).find_by(id: @ticket_id)
      return Result.new(false, nil, "Ticket not found") unless ticket
  
      full_name = ticket.purchase&.user&.full_name || "N/A"
  
      ticket_data = {
        id: ticket.id,
        ticket_category: ticket.ticket_category.name,
        event_date: ticket.event_date.strftime("%Y-%m-%d"),
        full_name: full_name,
        current_price: ticket.current_price,
        status: ticket.status
      }
  
      Result.new(true, ticket_data, nil)
    rescue => e
      Result.new(false, nil, e.message)
    end
  end
end
  