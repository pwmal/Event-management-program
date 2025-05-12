require 'rack'
require_relative 'ticket_service'
require_relative 'visitor_service'
require_relative 'journal_service'

class API_Gateway
  def self.call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when /^\/tickets/
      TicketsGateway.call(env)
    when /^\/visits/
      VisitorsGateway.call(env)
    when /^\/logs/
      JournalGateway.call(env)
    else
      [404, { 'Content-Type' => 'text/html' }, ['Not Found']]
    end
  end
end
