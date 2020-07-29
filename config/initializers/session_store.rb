if Rails.env === 'production'
  Rails.application.config.session_store :cookie_store, key: '_event_bit', domain: :all
else
  Rails.application.config.session_store :cookie_store, key: '_event_bit'
end