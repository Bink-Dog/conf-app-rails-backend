Rails.application.routes.draw do
  resources :events
  resources :users

  post "/start", to: "users#start"

  get "/image", to: "users#get_user_image"
 
end

