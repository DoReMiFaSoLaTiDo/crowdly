class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :auth_token, :created_at, :updated_at

  has_many :posts
end
