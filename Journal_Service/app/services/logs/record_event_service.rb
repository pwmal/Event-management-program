module Logs
  class RecordEventService
    Result = Struct.new(:success?, :message, :errors)

    def initialize(params)
      @params = params.to_h.symbolize_keys
    end

    def call
      log = Event.new(@params)

      if log.save
        Result.new(true, log, [])
      else
        Result.new(false, nil, log.errors.full_messages)
      end
    rescue => e
      Result.new(false, nil, [e.message])
    end
  end
end