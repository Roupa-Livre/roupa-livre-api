class PropertyCompleteSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :group_code, :sort_order, :parent_id
end
