Rails.application.routes.draw do
  resources :events
  resources :users
  # post "/signup", to: "users#create"
  # post "/login", to: "auth#login"

  post "/start", to: "users#start"

  get "/image", to: "users#get_user_image"

  # get "/auto_login", to: "auth#auto_login"
end

