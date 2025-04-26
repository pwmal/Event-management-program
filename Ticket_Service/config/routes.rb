Rails.application.routes.draw do
  get 'tickets/price', to: 'tickets#price'
  resources :tickets, only: [:show]
  post 'tickets/book', to: 'tickets#book'
  post 'tickets/buy',  to: 'tickets#buy'
  post 'tickets/cancel', to: 'tickets#cancel'
  post 'tickets/block', to: 'tickets#block'
  post 'tickets/mass_create', to: 'tickets#mass_create'
end
