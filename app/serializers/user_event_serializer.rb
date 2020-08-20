class UserEventSerializer < ActiveModel::Serializer
    attributes :id, :event_id, :user_id, :role, :user
end
  