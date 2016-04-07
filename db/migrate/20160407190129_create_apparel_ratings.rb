class CreateApparelRatings < ActiveRecord::Migration
  def change
    create_table :apparel_ratings do |t|
      t.references :apparel, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.boolean :liked, null: false

      t.timestamps null: false
    end
  end
end
