class CreateApparelImages < ActiveRecord::Migration
  def change
    create_table :apparel_images do |t|
      t.references :apparel, index: true, foreign_key: true, null: false
      t.string :file, null: false

      t.timestamps null: false
    end
  end
end
