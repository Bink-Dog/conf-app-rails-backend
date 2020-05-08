class UserSerializer < ActiveModel::Serializer
  attributes :email, :name, :twitter_handle, :company, :bio, :image_url
end
