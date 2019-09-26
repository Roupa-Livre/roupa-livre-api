class GlobalTagSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :body
end
