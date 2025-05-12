module Visits
  class MassCreateService
    Result = Struct.new(:success?, :message, :errors, :visits)
  
    def initialize(params)
      @ticket_ids = params[:ticket_ids]
    end
  
    def call
      return Result.new(false, "No ticket_ids provided", ["ticket_ids param is empty"], []) if @ticket_ids.blank?
  
      visits = []
      @ticket_ids.each do |ticket_id|
        visit = Visit.create!(ticket_id: ticket_id, status: "out")
        visits << visit
      end
  
      visits_data = visits.map { |v| { ticket_id: v.ticket_id, status: v.status } }
      Result.new(true, "Successfully created visits", [], visits_data)
    rescue => e
      Result.new(false, "Internal error", [e.message], [])
    end
  end
end
  