module Tickets
  class BlockService
    Result = Struct.new(:success?, :ticket_id, :status, :errors)
  
    def initialize(params)
      @ticket_id = params[:ticket_id]
      @document_number = params[:document_number]
      @reason = params[:reason]
    end
  
    def call
      ticket = Ticket.find_by(id: @ticket_id)
      return Result.new(false, nil, nil, "Ticket not found") unless ticket
  
      user = ticket.purchase&.user
      return Result.new(false, nil, nil, "Ticket not purchased") unless user
  
      if user.document_number != @document_number
        return Result.new(false, nil, nil, "Document number mismatch")
      end
  
      Ticket.transaction do
        ticket.update!(status: 'blocked')
  
        TicketBlock.create!(
          ticket_id: ticket.id,
          reason: @reason,
          blocked_at: Time.current
        )
      end
  
      Result.new(true, ticket.id, ticket.status, nil)
    rescue => e
      Result.new(false, nil, nil, "Internal error: #{e.message}")
    end
  end
end
  