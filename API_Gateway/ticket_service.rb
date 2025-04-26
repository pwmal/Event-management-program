require 'sinatra/base'
require 'net/http'
require 'uri'
require 'json'

class TicketsGateway < Sinatra::Base
  configure do
    # URL микросервиса управления билетами.
    set :ticket_service_url, ENV.fetch('TICKET_SERVICE_URL') { 'http://ticket-service:3000' }
  end

  before do
    content_type :json
  end

  #########################################
  # GET /tickets/price
  # Получение стоимости билета
  #########################################
  get '/tickets/price' do
    target_uri = URI("#{settings.ticket_service_url}/tickets/price")
    target_uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(target_uri)

    status response.code.to_i
    body response.body
  end

  #########################################
  # GET /tickets/:id
  # Получение информации о билете по ID
  #########################################
  get '/tickets/:id' do
    ticket_id = params['id']
    target_uri = URI("#{settings.ticket_service_url}/tickets/#{ticket_id}")
  
    response = Net::HTTP.get_response(target_uri)
  
    status response.code.to_i
    body response.body
  end

  #########################################
  # POST /tickets/book
  # Бронирование билета
  #########################################
  post '/tickets/book' do
    target_uri = URI("#{settings.ticket_service_url}/tickets/book")
    req = Net::HTTP::Post.new(target_uri, 'Content-Type' => 'application/json')
    req.body = request.body.read

    response = Net::HTTP.start(target_uri.hostname, target_uri.port) do |http|
      http.request(req)
    end

    status response.code.to_i
    body response.body
  end

  #########################################
  # POST /tickets/buy
  # Покупка билета
  #########################################
  post '/tickets/buy' do
    target_uri = URI("#{settings.ticket_service_url}/tickets/buy")
    req = Net::HTTP::Post.new(target_uri, 'Content-Type' => 'application/json')
    req.body = request.body.read

    response = Net::HTTP.start(target_uri.hostname, target_uri.port) do |http|
      http.request(req)
    end

    status response.code.to_i
    body response.body
  end

  #########################################
  # POST /tickets/cancel
  # Отмена бронирования билета
  #########################################
  post '/tickets/cancel' do
    target_uri = URI("#{settings.ticket_service_url}/tickets/cancel")
    req = Net::HTTP::Post.new(target_uri, 'Content-Type' => 'application/json')
    req.body = request.body.read

    response = Net::HTTP.start(target_uri.hostname, target_uri.port) do |http|
      http.request(req)
    end

    status response.code.to_i
    body response.body
  end

  #########################################
  # POST /tickets/block
  # Блокировка купленного билета
  #########################################
  post '/tickets/block' do
    target_uri = URI("#{settings.ticket_service_url}/tickets/block")
    req = Net::HTTP::Post.new(target_uri, 'Content-Type' => 'application/json')
    req.body = request.body.read

    response = Net::HTTP.start(target_uri.hostname, target_uri.port) do |http|
      http.request(req)
    end

    status response.code.to_i
    body response.body
  end

  #########################################
  # POST /tickets/mass_create
  # Массовое создание билетов
  #########################################
  post '/tickets/mass_create' do
    target_uri = URI("#{settings.ticket_service_url}/tickets/mass_create")
    req = Net::HTTP::Post.new(target_uri, 'Content-Type' => 'application/json')
    req.body = request.body.read

    response = Net::HTTP.start(target_uri.hostname, target_uri.port) do |http|
      http.request(req)
    end

    status response.code.to_i
    body response.body
  end

  #########################################
  # Обработка ошибок
  #########################################
  error do
    content_type :json
    status 500
    { error: env['sinatra.error'].message }.to_json
  end
end
