class CreateApparels < ActiveRecord::Migration
  def change
    create_table :apparels do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description
      t.string :size_info
      t.string :gender
      t.string :age_info

      t.timestamps null: false
    end
  end
end
