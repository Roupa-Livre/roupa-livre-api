# == Schema Information
#
# Table name: apparel_properties
#
#  id                     :integer          not null, primary key
#  apparel_id             :integer
#  cached_category_name   :string
#  category_id            :integer
#  cached_kind_name       :string
#  kind_id                :integer
#  cached_model_name      :string
#  model_id               :integer
#  cached_size_group_name :string
#  size_group_id          :integer
#  cached_size_name       :string
#  size_id                :integer
#  cached_pattern_name    :string
#  pattern_id             :integer
#  cached_color_name      :string
#  color_id               :integer
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class ApparelProperty < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :apparel
  belongs_to :category, class_name: "Property"
  belongs_to :kind, class_name: "Property"
  belongs_to :model, class_name: "Property"
  belongs_to :size_group, class_name: "Property"
  belongs_to :size, class_name: "Property"
  belongs_to :pattern, class_name: "Property"
  belongs_to :color, class_name: "Property"

  before_save :cache_property_values

  private
    def changed_property_name(property)
      property ? property.name : nil
    end

    def cache_property_values
      self.cached_category_name = changed_property_name(self.category) if category_id_changed?
      self.cached_kind_name = changed_property_name(self.kind) if kind_id_changed?
      self.cached_model_name = changed_property_name(self.model) if model_id_changed?
      self.cached_size_group_name = changed_property_name(self.size_group) if size_group_id_changed?
      self.cached_size_name = changed_property_name(self.size) if size_id_changed?
      self.cached_pattern_name = changed_property_name(self.pattern) if pattern_id_changed?
      self.cached_color_name = changed_property_name(self.color) if color_id_changed?
    end
end
