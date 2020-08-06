Rails.application.routes.draw do
  resources :eb_attendees
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

  get "/user-eventbrite-token", to: "users#get_user_eventbrite_token"

  post "/user-eventbrite-token", to: "users#set_user_eventbrite_token"

  post "/eb-attendees-batch-upload", to: "eb_attendees#batch_upload"

  get "/eb-attendees-attendee-count/:id", to: "eb_attendees#attendee_count"

  get "/home_info", to: "events#home_screen_data"

  post "/eventbright-register", to: "events#eventbright_register"

  post "/process-webhook", to: "events#process_webhook"

end

