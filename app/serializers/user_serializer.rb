class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :uid, :auth_provider, :auth_token, :twitter_handle, :github_username, :company, :bio, :image_url
end
