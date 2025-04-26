require 'net/http'
require 'json'

class TicketAdapter
  def self.fetch_ticket_data(ticket_id)
    begin
      uri = URI("http://ticket-service:3000/tickets/#{ticket_id}")
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body, symbolize_names: true)

        # { id: 1, ticket_category: "vip", event_date: "2025-06-01", full_name: "Иванов Иван", current_price: 123.45, status: "purchased/blocked" }
        {
          success: true,
          full_name: data[:full_name],
          ticket_category: data[:ticket_category],
          event_date: data[:event_date],
          status: data[:status]
        }
      else
        {
          success: false,
          message: "Ticket service error: #{response.body}"
        }
      end
    rescue StandardError => e
      {
        success: false,
        message: "TicketAdapter error: #{e.message}"
      }
    end
  end
end