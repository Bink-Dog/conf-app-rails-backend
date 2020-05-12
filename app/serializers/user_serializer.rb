class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :twitter_handle, :company, :bio, :image_url
end
