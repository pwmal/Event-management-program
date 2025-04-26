require 'sinatra/base'
require 'net/http'
require 'uri'
require 'json'

class JournalGateway < Sinatra::Base
  configure do
    set :journal_service_url, ENV.fetch('JOURNAL_SERVICE_URL') { 'http://journal-service:3000' }
  end

  before do
    content_type :json
  end

  #########################################
  # GET /logs
  #########################################
  get '/logs' do
    target_uri = URI("#{settings.journal_service_url}/logs")
    target_uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(target_uri)

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
