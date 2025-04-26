class LogsController < ApplicationController
  def get_journal
    permitted_params = params.permit(:ticket_id, :full_name, :event_type, :page)

    result = Logs::GetJournalService.new(permitted_params).call

    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def record_event
    permitted_params = params.permit(:ticket_id, :full_name, :time, :event_type, :status)

    result = Logs::RecordEventService.new(permitted_params).call

    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end
end