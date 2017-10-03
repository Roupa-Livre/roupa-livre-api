class ApparelPropertySerializer < ActiveModel::Serializer
  attributes :id, :apparel_id, :cached_category_name, :category_id, :cached_kind_name, :kind_id, :cached_model_name, :model_id, :cached_size_group_name, :size_group_id, :cached_size_name, :size_id, :cached_pattern_name, :pattern_id, :cached_color_name, :color_id
end
