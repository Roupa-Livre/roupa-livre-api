class CreatePropertyGroups < ActiveRecord::Migration
  def change
    create_table :property_groups do |t|
      t.string :code
      t.string :name
      t.string :prop_name
      t.string :property_segment
      t.integer :sort_order
      t.references :parent, index: true
      t.boolean :property_filter, default: false
      t.integer :filter_property_id, default: nil

      t.timestamps null: false
    end
  end
end
