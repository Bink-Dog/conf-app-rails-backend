Rails.application.routes.draw do
  resources :events
  resources :users
  resources :user_events

  post "/start", to: "users#start"

  post "/logout", to: "users#logout"

  get "/image", to: "users#get_user_image"

  post "user_events", to: "user_events#create"

  post "process-payment", to: "charges#charge_card"

  get "/get-future-events", to: "events#get_future_events"

  get "/get-past-events", to: "events#get_past_events"

 
end

