require_relative '../../adapters/visitor_adapter'
module Tickets
  class MassCreateService
    Result = Struct.new(:success?, :message, :errors, :tickets)
  
    def initialize(params)
      @category_name = params[:category_name]
      @base_price = params[:base_price]
      @count = params[:count]
      @event_date = params[:event_date]
    end
  
    def call
      category = TicketCategory.find_or_create_by(name: @category_name) do |cat|
        cat.base_price = @base_price || 1000.0
      end
  
      count = @count.to_i
      return Result.new(false, "Invalid count", ["Count must be a positive integer"]) if count <= 0
  
      created_tickets = []
  
      count.times do
        ticket = Ticket.create!(
          event_date: @event_date || Date.today + 30,
          current_price: category.base_price,
          status: "available",
          ticket_category: category
        )
        created_tickets << ticket
      end
  
      ticket_data = created_tickets.map { |t| { id: t.id, status: t.status, category: category.name } }

      ticket_ids = ticket_data.map { |t| t[:id] }
      visitor_result = ::VisitorAdapter.mass_create_visits(ticket_ids)

      if visitor_result[:success]
        Result.new(true, "Successfully created #{created_tickets.count} tickets and visits", [], ticket_data)
      else
        Result.new(false, "Tickets created, but failed to create visits", [visitor_result[:message]], ticket_data)
      end
    rescue => e
      Result.new(false, "Internal error", [e.message], [])
    end
  end
end
  