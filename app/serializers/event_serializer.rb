class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :host_user, :price, :description, :start_time, :finish_time, :timezone, :venue, :venueData, :eventbrite_id, :static_venue_data
end
