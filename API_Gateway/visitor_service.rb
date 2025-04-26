require 'sinatra/base'
require 'net/http'
require 'uri'
require 'json'

class VisitorsGateway < Sinatra::Base
  configure do
    set :visitor_service_url, ENV.fetch('VISITOR_SERVICE_URL') { 'http://visitor-service:3000' }
  end

  before do
    content_type :json
  end

  #########################################
  # PATCH /visits/enter
  #########################################
  patch '/visits/enter' do
    target_uri = URI("#{settings.visitor_service_url}/visits/enter")
    req = Net::HTTP::Patch.new(target_uri, 'Content-Type' => 'application/json')
    req.body = request.body.read

    response = Net::HTTP.start(target_uri.hostname, target_uri.port) do |http|
      http.request(req)
    end

    status response.code.to_i
    body response.body
  end

  #########################################
  # PATCH /visits/exit
  #########################################
  patch '/visits/exit' do
    target_uri = URI("#{settings.visitor_service_url}/visits/exit")
    req = Net::HTTP::Patch.new(target_uri, 'Content-Type' => 'application/json')
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
