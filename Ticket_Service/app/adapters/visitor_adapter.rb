require 'net/http'
require 'json'

class VisitorAdapter
  def self.mass_create_visits(ticket_ids)
    begin
      uri = URI("http://visitor-service:3000/visits/mass_create")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
      request.body = { ticket_ids: ticket_ids }.to_json

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        {
          success: true,
          message: "Visits created successfully"
        }
      else
        {
          success: false,
          message: "Visitor service error: #{response.body}"
        }
      end
    rescue StandardError => e
      {
        success: false,
        message: "VisitorAdapter error: #{e.message}"
      }
    end
  end
end
