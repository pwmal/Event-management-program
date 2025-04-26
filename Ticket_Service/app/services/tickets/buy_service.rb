module Tickets
  class BuyService
    Result = Struct.new(:success?, :message, :errors)
  
    def initialize(params)
        @book_id = params[:book_id]
        @full_name = params[:full_name]
        @document_type = params[:document_type]
        @document_number = params[:document_number]
        @user_email = params[:email]
        @date_of_birth = params[:date_of_birth]
    end
  
    def call
      booking = Booking.find_by(id: @book_id)
      return Result.new(false, nil, "Booking not found") unless booking
  
      if Time.current > booking.expires_at
        return Result.new(false, nil, "Booking expired")
      end
  
      unless valid_age?(@date_of_birth)
        return Result.new(false, nil, "User must be at least 14 years old")
      end
  
      ticket = booking.ticket
  
      user = find_or_create_user
      return Result.new(false, nil, user.errors.full_messages) unless user.persisted?
  
      purchase = Purchase.create(
        ticket: ticket,
        user: user,
        purchase_date: Time.current
      )
  
      if purchase.persisted?
        ticket.update(status: 'purchased')
        booking.update(status: 'purchased')
        Result.new(true, "Purchase successful #{ticket.id}", nil)
      else
        Result.new(false, nil, purchase.errors.full_messages)
      end
    rescue => e
      Result.new(false, nil, "Internal error: #{e.message}")
    end
  
    private
  
    def valid_age?(dob)
      return false unless dob.present?
      dob = Date.parse(dob)
      dob <= 14.years.ago.to_date
    rescue ArgumentError
      false
    end
  
    def find_or_create_user
      user = User.find_by(email: @user_email)
      if user
        user
      else
        User.create(
          full_name: @full_name,
          email: @user_email,
          document_type: @document_type,
          document_number: @document_number,
          date_of_birth: @date_of_birth
        )
      end
    end
  end
end
  