class VisitsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update_status
    result = Visits::UpdateStatusService.new(visit_params).call

    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end 
  end

  def mass_create
    permitted = params.permit(ticket_ids: [])

    result = Visits::MassCreateService.new(permitted).call

    if result.success?
      render json: { message: result.message, visits: result.visits }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def visit_params
    params.require(:visit).permit(:ticket_id, :zone, :event_date, :action)
  end
end