class CreateApparelTags < ActiveRecord::Migration
  def change
    create_table :apparel_tags do |t|
      t.references :apparel, index: true, foreign_key: true, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
