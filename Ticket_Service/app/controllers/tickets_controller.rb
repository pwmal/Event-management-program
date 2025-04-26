class TicketsController < ApplicationController
#   skip_before_action :verify_authenticity_token
  def price
    permitted_params = params.permit(:category, :event_date)

    result = Tickets::PriceService.new(permitted_params).call

    if result.success?
      render json: { price: result.data }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def show
    result = Tickets::ShowService.new(params[:id]).call

    if result.success?
      render json: result.message, status: :ok
    else
      render json: { error: result.errors }, status: :not_found
    end
  end

  def book
    permitted_params = params.permit(:ticket_category_name, :event_date)
    result = Tickets::BookService.new(permitted_params).call
    
    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def buy
    permitted_params = params.permit(:book_id, :full_name, :document_type, :document_number, :email, :date_of_birth)
    result = Tickets::BuyService.new(permitted_params).call

    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def cancel
    permitted_params = params.permit(:book_id)
    
    result = Tickets::CancelService.new(permitted_params[:book_id]).call

    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def block
    permitted = params.permit(:ticket_id, :document_number, :reason)

    result = Tickets::BlockService.new(permitted).call
  
    if result.success?
      render json: { ticket_id: result.ticket_id, status: result.status }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def mass_create
    permitted = params.permit(:category_name, :base_price, :count, :event_date)

    result = Tickets::MassCreateService.new(params).call
  
    if result.success?
      render json: { message: result.message, tickets: result.tickets }, status: :created
    else
      render json: { error: result.message, details: result.errors }, status: :unprocessable_entity
    end
  end
  
end
  
