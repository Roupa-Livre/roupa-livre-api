class CreateApparelReports < ActiveRecord::Migration
  def change
    create_table :apparel_reports do |t|
      t.references :apparel, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :number
      t.string :reason

      t.timestamps null: false
    end
  end
end
