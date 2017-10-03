class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :code
      t.integer :sort_order
      t.string :segment, index: true

      t.timestamps null: false
    end
  end
end
