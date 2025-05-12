Rails.application.routes.draw do
  get  '/logs', to: 'logs#get_journal'
  post '/logs/record', to: 'logs#record_event'
end
