if Rails.env === 'production'
  Rails.application.config.session_store :cookie_store, key: '_event_bit', domain: 'conf-game.herokuapp.com', same_site: :none, secret: "hazelnut", secure: true
else
  Rails.application.config.session_store :cookie_store, key: '_event_bit', same_site: :none
end