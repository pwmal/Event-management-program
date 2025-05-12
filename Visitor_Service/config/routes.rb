Rails.application.routes.draw do
  patch "visits/enter", to: "visits#update_status"
  patch "visits/exit",  to: "visits#update_status"
  post "visits/mass_create", to: "visits#mass_create"
end
