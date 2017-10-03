class CreateApparelProperties < ActiveRecord::Migration
  def change
    create_table :apparel_properties do |t|
      t.references :apparel, index: true, foreign_key: true
      t.string :cached_category_name
      t.belongs_to :category, index: true
      t.string :cached_kind_name
      t.belongs_to :kind, index: true
      t.string :cached_model_name
      t.belongs_to :model, index: true
      t.string :cached_size_group_name
      t.belongs_to :size_group, index: true
      t.string :cached_size_name
      t.belongs_to :size, index: true
      t.string :cached_pattern_name
      t.belongs_to :pattern, index: true
      t.string :cached_color_name
      t.belongs_to :color, index: true
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
    add_index :apparel_properties, :apparel_id, name: 'apparel_property_unique_apparel', unique: true
  end
end
