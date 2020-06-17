class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :host_user, :price, :description, :start, :end
end
