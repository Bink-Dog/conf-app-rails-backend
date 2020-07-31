class EbAttendeeSerializer < ActiveModel::Serializer
  attributes :id, :user_eventbrite_id, :email, :used
end
