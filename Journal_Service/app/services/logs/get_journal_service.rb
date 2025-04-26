module Logs
  class GetJournalService
    Result = Struct.new(:success?, :message, :errors)

    def initialize(params)
      @params = params.to_h.symbolize_keys
    end

    def call
      logs = Event.all

      logs = logs.where(ticket_id: @params[:ticket_id]) if @params[:ticket_id].present?
      logs = logs.where("full_name ILIKE ?", "%#{@params[:full_name]}%") if @params[:full_name].present?
      logs = logs.where(event_type: @params[:event_type]) if @params[:event_type].present?

      page = (@params[:page] || 1).to_i
      logs = logs.limit(30).offset((page - 1) * 30)

      data = logs.map do |log|
        {
          ticket_id: log.ticket_id,
          full_name: log.full_name,
          timestamp: log.time,
          event_type: log.event_type,
          status: log.status
        }
      end

      Result.new(true, data, [])
    rescue => e
      Result.new(false, nil, [e.message])
    end

  end
end