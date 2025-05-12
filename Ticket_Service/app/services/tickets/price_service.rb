module Tickets
  class PriceService
    Result = Struct.new(:success?, :data, :errors)

    def initialize(params)
      @params = params.to_h.symbolize_keys
    end

    def call
      ticket_category = TicketCategory.find_by(name: @params[:category])
    
      return Result.new(false, nil, "Category not found") unless ticket_category

      tickets = Ticket.where(ticket_category: ticket_category, event_date: @params[:event_date])

      total_tickets = tickets.count
      sold_tickets = tickets.where(status: ["booked", "blocked", "purchased"]).count

      return Result.new(false, nil, "No tickets found for the given date") if total_tickets == 0

      sold_percentage = (sold_tickets.to_f / total_tickets.to_f) * 100

      price_multiplier = (sold_percentage / 10).to_i * 0.1
      current_price = ticket_category.base_price * (1 + price_multiplier)

      Result.new(true, current_price, nil)
    rescue => e
      Result.new(false, nil, "Internal error: #{e.message}")
    end
  end
end