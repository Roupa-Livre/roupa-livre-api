class AddDeletedAtToApparelRating < ActiveRecord::Migration
  def change
    add_column :apparel_ratings, :deleted_at, :datetime
    add_index :apparel_ratings, :deleted_at
  end
end
