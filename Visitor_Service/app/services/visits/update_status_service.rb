module Visits
  class UpdateStatusService
    Result = Struct.new(:success?, :message, :errors)

    def initialize(params)
      @params = params.to_h.symbolize_keys
    end

    def call
      visit = Visit.find_by(ticket_id: @params[:ticket_id])
      return Result.new(false, nil, ["Visitor not found"]) unless visit

      # { id: 1, ticket_category: "vip", event_date: "2025-06-01", full_name: "Иванов Иван", current_price: 123.45, status: "purchased/blocked" }
      ticket_data = TicketAdapter.fetch_ticket_data(@params[:ticket_id])
      return Result.new(false, ticket_data[:message], ["Failed to fetch ticket data"]) unless ticket_data[:success]

      if ticket_data[:status] != "purchased"
        return Result.new(false, nil, ["Ticket status must be 'purchased', got '#{ticket_data[:status]}'"])
      end
      
      if @params[:zone].to_s != ticket_data[:ticket_category].to_s
        return Result.new(false, nil, ["Zone mismatch: expected #{ticket_data[:ticket_category]}"])
      end

      if Date.parse(@params[:event_date]) != Date.parse(ticket_data[:event_date])
        return Result.new(false, nil, ["Event date mismatch: expected #{ticket_data[:event_date]}"])
      end

      if invalid_transition?(visit, @params[:action])
        return Result.new(false, nil, ["Invalid status transition"])
      end

      if @params[:action] == "enter"
        new_status = "in"
      end

      if @params[:action] == "exit"
        new_status = "out"
      end
      
      if visit.update(status: new_status)
        MessagePublisher.publish(
            ticket_id: visit.ticket_id,
            full_name: ticket_data[:full_name],
            time: Time.now.utc.iso8601,
            event_type: @params[:action],
            status: "success"
        )
        Result.new(true, "Status updated successfully", [])
      else
        Result.new(false, nil, visit.errors.full_messages)
      end
    end

    private

    def invalid_transition?(visit, action)
      return true if (visit.status == "in" && action == "enter")
      return true if (visit.status == "out" && action == "exit")
    end
  end
end