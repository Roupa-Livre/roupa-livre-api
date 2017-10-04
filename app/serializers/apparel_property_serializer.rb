class ApparelPropertySerializer < ActiveModel::Serializer
  attributes :id, :apparel_id, :category_id, :kind_id, :model_id, :size_group_id, :size_id, :pattern_id, :color_id
end
