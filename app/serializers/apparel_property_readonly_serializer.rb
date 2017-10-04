class ApparelPropertyReadonlySerializer < ActiveModel::Serializer
  attributes :id, :cached_category_name, :cached_kind_name, :cached_model_name, :cached_size_group_name, :cached_size_name, :cached_pattern_name, :cached_color_name
end
